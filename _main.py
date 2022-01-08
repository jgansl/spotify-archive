from spotipy.client import PLAYLIST, SAVED, TRACK#, Personal
from spotipy.exceptions import SpotifyException
from _oauth import sp, usr

import concurrent
from math import ceil
from concurrent.futures import as_completed, ThreadPoolExecutor
from json import load, dump, dumps
from os import getenv, system
from pydash import flatten
from time import sleep
import re #! reduce dep
import json

jprint = lambda x: print(json.dumps(x,indent=2))

#improve how to analyze anad categorize autdio - dividing sounds - sound calassification organiation ml
# track number
class Track(): #Document):
   # sid: String = StringField()
   # genrenum: Int = IntField() #classification vs personal mix

   name = ""

sp_plst = [] #auto - iheart

# add songs to new / Release - daily, radio
# https://open.spotify.com/user/tgansler?si=927f5c58f631429d
def newRelease(): # scan for new/unfollowed artists only and egt top tracks/popular
   radio_mixes = [p for p in plst if 'Radio' in p['name']]
   # coll = set(mem.sids)
   # coll.update(mem.get_track_ids(mem.pname('Cache')))
   pcach = mem.pname('Cached')
   cach=mem.get_track_ids(pcach)
   daily_mixes = [p for p in plst if 'Daily Mix' in p['name'][:9]]
   for p in flatten([radio_mixes, daily_mixes]): # thread?
      #get diff tracks
      # 
      # print(len(mem.get_track_ids(p)))
      # print(len(cach))
      lst = mem.diff(mem.get_track_ids(p), cach)
      print(p['name'], len(lst))
      mem.move(None, 'SAVED', lst)
      mem.move(None, pcach['id'], lst)
      cach=mem.get_track_ids(mem.pname('Cached'))

   #cache -> supabase


def yt(): #sync
   return


# remove genre/ numbers from songs

# supabase caching - cache after 14 days or over 3000 - retrive artsits/recommendations - artists

# playlist of completely new artists

# retrain model

class Personal(object):
   def __init__(self, client=None):
      # self.sp = client
      # if not client:
      #    self.sp = sp
      self.playlists = self.retrieve(PLAYLIST)
      self.saved = self.retrieve(SAVED) # lazy init
      self.sids = [s['track']['id'] for s in self.saved]
      self.mem = {}
   
   def _paginate(self, func, *args, **kwargs):
    
      data = []
      lim = 50  # ! if not lim
      pack = {}
      if "lim" in kwargs.keys():
         lim = kwargs["lim"]
      pack["limit"] = lim
      if "pid" in kwargs.keys():
         pack['user'] = usr
         pack['playlist_id'] = kwargs["pid"]

      # init
      res = func(**pack)
      total = res["total"]
      data = res['items']

      if total > lim:
         with ThreadPoolExecutor(max_workers=15) as executor:
               future_res = {
                  executor.submit(func, offset=i*lim, **pack): i for i in range(1, ceil(total / lim))
               }
               for future in as_completed(future_res):
                  data.extend(future.result()["items"])

         # sort
      return data

   def retrieve(self, typ, pid=None, *args, **kwargs,):  # !TIDS
      # global sp, cache  # !cache
      mp = {
         PLAYLIST: sp.current_user_playlists,
         SAVED: sp.current_user_saved_tracks,
         TRACK: sp.user_playlist_tracks,
      }

      if typ.lower().strip() == SAVED:
         # if 'saved' not in [*mem]:
         #     mem['saved'] = {"name": "saved", "tracks": None, "tids": None}
         # if mem['saved']['tracks']:
         #     return mem['saved']['tracks']
         # else:
         res = self._paginate(sp.current_user_saved_tracks, *args, **kwargs)
         for t in res:
            del t['track']['album']['available_markets']
            del t['track']['available_markets']
         return res
      elif typ.lower().strip() == PLAYLIST:
         res = self._paginate(sp.current_user_playlists, *args, **kwargs)
         # id & type ++> pid and sid same?
         #! ? name, history, keywords..

         return res
      elif typ.lower().strip() == TRACK:
         res = self._paginate(sp.user_playlist_tracks, pid=pid,
                           *args, user=usr, **kwargs)
         for t in res:
            try:
               del t['track']['album']['available_markets']
               del t['track']['available_markets']
            except: pass
         return res
      # elif typ.lower().strip() == ARTIST_ALBUMS:  # multiple artiusts?
      #    pass
   
   def move(self, src, dst, items=[], owned=True, limit=50):
      print(len(items), 'being moved..')
      def parallel(src, dst, items=[], owned=True):
         # print(dst)
         if dst:
            if dst.lower() == SAVED:
               try:
                  snpsht = sp.current_user_saved_tracks_add(tracks=items)
               except SpotifyException:
                  for i in items:
                     try:
                        snpsht = sp.current_user_saved_tracks_add(tracks=[i])
                     except: #!
                        pass
            else:
               try:
                  snpsht = sp.user_playlist_add_tracks(
                     user=usr, playlist_id=dst, tracks=items
                  )
                  if snpsht:
                     pass  # log(0, snpsht)  # log(0, err)
               # non existent IDs - spotipy.client.SpotifyException, requests.exceptions.HTTPError
               except SpotifyException:
                  grace = False
                  for i in items:
                     try:
                        snpsht = sp.user_playlist_add_tracks(
                           user=usr, playlist_id=dst, tracks=[i]
                        )
                        if snpsht:
                           pass  # print("ADDING", snpsht)
                     except SpotifyException:
                        if not grace:
                           #!log(1, "Skipped adding track..")
                           pass
                        grace = True
                        continue

         # src removal
         if src:
            if src.lower() == SAVED:
               snpsht = sp.current_user_saved_tracks_delete(tracks=items)
            elif src:
               if owned:
                  # TODO internally check that it is a list of string ids
                  snpsht = sp.user_playlist_remove_all_occurrences_of_tracks(
                     user=usr, playlist_id=src, tracks=items, snapshot_id=None
                  )
                  # sp.user_playlist_remove_tracks(user=usr, playlist_id=lst[i]['pid'], tracks=t)
                  # if snpsht:
                  #    print("REMOVE", snpsht)
         return
      #! AttributeError: 'dict' object has no attribute 'lower' -> ID, check if dict
      if type(src) == 'dict':
         src = src['id']
      if type(dst) == 'dict':
         dst = dst['id']
      if src and SAVED in src.lower():
         src = SAVED
      if dst and SAVED in dst.lower():
         dst = SAVED
      # jprint(items)
      if not len(items):
         return

      executor = ThreadPoolExecutor(max_workers=7)
      reqs = len(items) // limit
      # print(reqs)

      for i in range(reqs):
         print("Submitted", str(i))
         # executor.submit(parallel, src, dst,
         #                   items[i * 50: i * 50 + 50], owned=owned)
         parallel(src, dst, items[i * 50: i * 50 + 50], owned=owned)
      # executor.submit(parallel, src, dst,
      #                items[reqs * 50: len(items)], owned=owned)
      parallel(src, dst, items[reqs * 50: len(items)], owned=owned)
      return 
   
   def tids(self, tdicts: list) -> list:
      return

   def sids(self):
      return
   
   def pname(self, name: str, cont=None, refreshed=False, equal=True, create=True, ownly=False, description='') -> dict:  # !
      # global playlists
      if equal:
         res = [p for p in self.playlists if name.lower() == p['name'].lower()
                  ]  # new vs newaritst
         if ownly:
            res = [p for p in res if p['owner']['id'] == usr]
      else:
         res = [p for p in self.playlists if name.lower() in p['name'].lower()]  # dm
         if ownly:
               res = [p for p in res if p['owner']['id'] == usr]
      if not cont and len(res) > 1:
         for p in res:
               print(p['name'])
         # !
         response = input(
            f'multiple playlist that contain {name}. continue? index0?').strip()
         if response.lower() == 'y':
            return res[0]
         if response.isdigit():
            print('using ' + res[int(response)]['name'])
            sleep(1.5)
            return res[int(response)]

      elif len(res):
         return res[0]
      # elif not refreshed:
      #     playlists = retrieve(PLAYLIST)
      #     return pname(name, refreshed=True)
      elif create:
         print('Creating')
         res = sp.user_playlist_create(usr, name, public=False, collaborative=False, description=description)
         while res['name'] not in [p['name'] for p in self.playlists]:
               self.playlists = self.retrieve(PLAYLIST)
               sleep(2)        
         return res
   
   def get_track_ids(self, p):
      try:
         return [t['track']['id'] for t in self.retrieve(TRACK, pid=p['id'])]
      except:
         lst = []
         for t in self.retrieve(TRACK, pid=p['id']):
            try: #!
               lst.append(t['track']['id'])
            except:
               pass

   def prcs(self, a, b):
      if a == SAVED:
         a = self.sids
      elif type(a) == str: #! assume id..or NAME
         a = self.get_track_ids(self.pname(a))
      elif type(a) == dict: #! assume id..or NAME
         a = self.get_track_ids(a)

      if b == SAVED:
         b = self.sids
      elif type(b) == str: #! assume id..or NAME
         b = self.get_track_ids(self.pname(b))
      elif type(b) == dict: #! assume id..or NAME
         b = self.get_track_ids(b)
      #lse list of track_ids
      return a, b
   def diff(self, a, b):
      a, b = self.prcs(a,b)
      return list(set(a) - set(b))
   def intersect(self, a, b):
      a, b = self.prcs(a,b)
      return list(set(a).intersection(set(b)))

#! split up into periodic tasks thoughout the days
#! check about creating new collection for radio_mix - bliss city
#! remove sg from enjoy music
#! sg caches
#! remove nostalgia from emmeroies

if __name__ == '__main__': #!! how are songs recommended by playlist content?
   
   mem = Personal(sp)
   ret = mem.retrieve
   mov = mem.move
   dif = mem.diff
   ints = mem.intersect
   pnm = mem.pname
   plst = mem.playlists
   tds = lambda lst: [t['track']['id'] for t in lst] #! none
   # playlists = sp.retrieve(PLAYLIST)


   patch = False
   if patch:
      input('Patching?')
      #! remove genre from untracked
      #! remove form cache, tmp
      #!
      # mov(None, pnm('tmp' + str(len(mem.sids)))['id'], mem.sids)

      # unfollow erroreuos playlist
      # for i in [
      #    # old daily mixes
      #    '37i9dQZF1E35SIWCjaxbHF',
      #    '37i9dQZF1E34UuF3TsII7q',
      #    '37i9dQZF1E35G7d2DfpoRy',
      #    '37i9dQZF1E39o8wOEkYZdI',
      #    '37i9dQZF1E3adKP3MJpilp',
      #    '37i9dQZF1E3acQI61k2jN8',
      # ]:
      #    print(sp.playlist(i)['owner']['id'])
      #    sp.current_user_unfollow_playlist(playlist_id=i)
      #    sp.current_user_follow_playlist(playlist_id=i)
      #    continue
      exit()
   else:

      # back up saved
      dst = pnm('Untracked')
      mov(None, dst['id'], dif(SAVED, dst))
      
      #remove nostalgia/memoreis from music
      
      #! memories
      mus = pnm('Enjoy Music')
      src = mus
      dst = pnm('Nostalgia')
      mov(src['id'], dst['id'], ints(src, dst))
      src = pnm('Untracked')
      dst = pnm('Nostalgia')
      mov(src['id'], dst['id'], ints(src, dst))
      cache = pnm('Cached - Auto Remove')
      cplst = pnm('Cache')
      newr = pnm('New / Release')
      coll = set()

      #! thread
      # for p in [p for p in mem.playlists if 'Radio' in p['name'] or ('Mix' in p['name'] and 'Daily' not in p['name']) and 'yt' not in p['description']]:
      def _tradios(p):  
         nm = re.sub('(Mix|Radio)', 'Collection', p['name'])
         ref = pnm(nm)
         # if (ref):
         #    sp.current_user_unfollow_playlist(ref['id'])
         # continue
         # sleep(1)
         # ref = pnm(p['name'].replace('Mix', 'Collection'))
         lst = dif(p, ref)
         # if ref['name'] ==  'Funk Collection':
         #    continue
         # mov(None, ref['id'], lst)
         mov(cache['id'], ref['id'], lst)
         mov(cplst['id'], None, lst)
         mov(newr['id'], None, lst)
         # input('Continue? ' + str(len(lst)))
         # print(nm, len(lst))
         coll.update(mem.get_track_ids(ref))
         sleep(3)
         return (p['name'], len(lst))
      with concurrent.futures.ThreadPoolExecutor(max_workers=10) as executor:
         # Start the load operations and mark each future with its URL
         future_to_p = {executor.submit(_tradios, p): p for p in [p for p in mem.playlists if 'Radio' in p['name'] or ('Mix' in p['name'] and 'Daily' not in p['name']) and 'yt' not in p['description']]}
         for future in concurrent.futures.as_completed(future_to_p):
            p = future_to_p[future]
            try:
                  data = future.result()
            except Exception as exc:
                  print('%r generated an exception: %s' % (url, exc))
            else:
               # print('%r page is %d bytes' % (url, len(data)))
               print(data)
      # exit()
      #! e.submit below all
      coll.update(mem.sids)
      coll.update(mem.get_track_ids(cache))
      coll.update(mem.get_track_ids(cplst))
      coll.update(mem.get_track_ids(newr))
      for p in [
         'Nostalgia',
         'Apple Music',
         'Enjoy Music',
         'Untracked',
         'Calm - Artists, Refine',
         '2021 Collection',
         'Guitar',
         'Sing/Play', 
         # personal tag
      ]:
         print(p)
         coll.update(mem.get_track_ids(pnm(p)))
         #! start radio from liekd song - untrack and 
      #! mixes / radio # pack remove tracks#! add song to artsit explored to auto pull in artists tracks - radio
      #! add remaining to new/release hidden - how to tell?#! spotify hide/untracked
      #! discover, new music, release -> new / release
      #! add _ removals from enjoy, cache, new/release, add to coll
      #! personal; addition channeling removal - i.e. memories from nostaglia, etc.
      #! integrate folders
      for i, p in enumerate([p for p in mem.playlists if 'Daily Mix' in p['name']]):
         ref = pnm(re.sub('Mix.*', 'New ' + str(i), p['name']))
         trks = mem.get_track_ids(ref)
         mov(ref['id'], None, ints(trks, coll)) #! personal
         coll.update(trks)
      for i, p in enumerate([p for p in mem.playlists if 'Daily Mix' in p['name']]):
         # print(i, p['id'])
         lst = mem.get_track_ids(p)
         # mov(None, newr['id'], dif(coll, lst)) #! ? keep separate
         ref = pnm(re.sub('Mix.*', 'New ' + str(i), p['name']))
         sleep(2)
         # mov(None, pnm(re.sub('Mix', 'New', p['name']))['id], dif(coll, lst)) #! ? keep separate

         #! move old to cache - double
         coll.update(mem.get_track_ids(ref))
         try:
            if len(dif(lst, coll)):
               #! move to new / Release and replace
               mov(ref['id'], pnm('New / Release')['id'], mem.get_track_ids(ref)) #added to coll above prev loop
               sp.user_playlist_add_tracks(usr, ref['id'], dif(lst, coll)) #! ? keep separate
               mov(cache['id'], ref['id'], lst)
               mov(cplst['id'], None, lst)
               mov(newr['id'], None, lst)
         except:
            #move new into cache/ new/release/liked -> if in new release and not saved remove coll ^
            print('Err for DM' + str(i))
            pass
      # ref = pnm('Cached - Auto Remove')
      # prev = mem.get_track_ids(ref)[:25] #!
      # mov(ref['id'], SAVED, mem.get_track_ids(ref)[:25])



      # newRelease()
      
      # remove eprsonal from saved

      # remove genre ?  from savedmusic -> liked playlists -> add liked to general/cache

      #exec spotipy web client nodejs - listen -> app

      # troy playlsits
      # move artcolls - from new/release

      # patch - remove year from music
      
      # app for user data

      # auto number outlier resolver

      #