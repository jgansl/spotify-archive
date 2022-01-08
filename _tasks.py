# single operations
from spotipy.client import PLAYLIST, SAVED, TRACK#, Personal
from spotipy.exceptions import SpotifyException
from _oauth import sp, usr

from datetime import datetime
from math import ceil
from concurrent.futures import as_completed, ThreadPoolExecutor
from json import load, dump, dumps
from os import getenv, system
from pydash import flatten
from time import sleep
import re #! reduce dep
import json

from _main import Personal


if __name__ == '__main__':
    # import sys
    # sys.path.append('..')
    cache = {} #!load
    mem = Personal(sp)
    ret = mem.retrieve
    mov = mem.move
    dif = mem.diff
    ints = mem.intersect
    pnm = mem.pname
    plst = mem.playlists
    tds = lambda lst: [t['track']['id'] for t in lst] #! none
    # playlists = sp.retrieve(PLAYLIST)

    def test():
        
        exit()
    # test()

    def draft():
        for s,d in [
            ('Enjoy Music', 'Nostalgia'),
            (SAVED, 'Nostalgia'),
            (SAVED, '2021 Collection'), #ref
            (SAVED, 'Folk & Acoustic Collection'),
        ]:
            # for i in [s,d]:
            #     if i in [*cache]:
            #         i = cache[i]
            #     else:
            #         i = pnm(i)
            #         cache[i['name']] = i
            if SAVED != s and s in [*cache]:
                sid = cache[s]['id']
            elif SAVED != s: 
                cache[s] = pnm(s)
                sid = cache[s]['id']
            else: 
                sid = SAVED
            if SAVED != d and d in [*cache]:
                did = cache[d]['id']
            elif SAVED != d:
                cache[d] = pnm(d)
                did = cache[d]['id']
            else:
                did = SAVED
            
            mov(sid, did, ints(s, d))
    

    #! cache successful for day
    dt = datetime.now().day
    coll=set(mem.sids)
    # coll.update() #! load and async update
    def channel():
        channels = {
            'Chill Music': 'Chill Music Collection',
            'Choice Edit':'New / Release',
            'New Pop Picks':'Pop Collection',
            'Singled Out':'New / Release',
            'Soft Pop Hits':'Pop Collection',
            'Space Lo-Fi':'Lofi/Bedroom Collection',
            'Today\'s Top Hits':'New / Release',
        }
        weekly = [
            [],[],
            #monday
            ['Discover Weekly'],
            [],[],[],[], 
            #friday
            [
            'New Music Friday',
            'Release Radar'
            ]
        ]
        nr = 'New / Release'
        cache = 'Cache'
        def _f(i):
            ref=pnm(i)
            mov(None,nr, dif(i, nr))
            mov(None,cache, dif(i, cache))
        for i in weekly[datetime.now().day]:
            _f(i)
        for i in [*channels]:
            ref=pnm(i)
            ref2=pnm(channels[i])
            mov(None,ref,dif(ref, ref2)) #!check cache
            #! update coll -> remove from cache -auto update, new lreearrt
            #! remove savd,enjoy music
        return
    def cleanup():
        lst = [
            'tmp 6112',
            'tmp 5112',
            'tmp 4062',
            'tmp 3060',
            'tmp 2060',
        ]
    channel()
    #! move cache from colllections
    #! remove memories and .personal from saved..enjoy music
    #! remove spotify genre from saved (once a week)
    #! add new release to saved
    #! remove memories and saved from enjoy music,'nostaligai from ej
    #! remove sing/play from enjoy music, saved -> scalable
    #!kotlin spotify graphql ->flutter app
    #! filter new / release; dailymix training ml
    #! remove personal from liked, memories#! shazam
    ref = pnm('Cached - Auto ')
    mov(ref, None, ints(coll, ref)))
    def daily(): #! coll

        return
    daily()
    #! private except #public
    #! supabase cache remove
    exit()

    # not save
    for s,d in [
        ('Enjoy Music', 'Nostalgia'),
        ('Enjoy Music', 'Folk & Acoustic Collection'), #no dup
        ('Enjoy Music', '2021 Collection'),
    ]:
        s = pnm(s)
        d = pnm(d)
        mov(s['id'], d['id'], ints(s, d))
    # from saved name of playlist
    for p in [
        'Nostalgia',
        '2021 Collection',
        'Folk & Acoustic Collection', #genre, oersonal, memory 
    ]:
        ref = pnm(p)
        mov(SAVED, ref['id'], ints(mem.sids,ref))
    em=pnm('Enjoy Music')
    mov(em['id'], SAVED, ints(mem.sids, em))
    exit()
    coll = set()
    for i in [*cache]:
        coll.update(mem.get_track_ids(cache[i]))
    for p in [p for p in mem.playlists if '.personal' in p['description']]:
        coll.update(mem.get_track_ids(p))

    # integrate
    # collections -> spotify playlist collections or channel
    # remove cache from all collections

    #monday discover weekly -> coll New Release


    # daily mixes only new