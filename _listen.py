import os, json
from time import sleep
from supabase import create_client, Client
from _oauth import sp,usr

url: str = os.environ.get("SUPABASE_URL")
key: str = os.environ.get("SUPABASE_KEY")
supabase: Client = create_client(url, key)
# Create a random user login email and password.
random_email: str = "3hf82fijf92@supamail.com"
random_password: str = "fqj13bnf2hiu23h"
# user = supabase.auth.sign_up(email=random_email, password=random_password)
# user = supabase.auth.sign_in(email=random_email, password=random_password)

table="tracks"
# cur = sp.currently_playing()['item']
#! if not exists - sid
# data = supabase.table(table).insert({"sid":cur['id'], "name":cur['name'], 'playcount':1}).execute()
# assert len(data.get("data", [])) > 0
# print(data.get("data", []))

fn = 'data/last.txt'
last = None #redis
if os.path.exists(fn):
   with open(fn, 'r') as f:
      last = f.read().strip()
   print(last)
while 1:
   res = sp.currently_playing()
   if not res:
      print('Not Playing')
      sleep(3)
      continue

   song = res['item']
   sid = song['id']

   if last != sid:
      #! backup
      # Assert we pulled real data.
      data = supabase.table(table).select("*").eq('sid', sid).execute()
      data = data.get("data", [])
      # assert 
      if not len(data):# > 0
         obj = {
            "sid":sid, 
            "name":song['name'], 
            'playcount':1,
            #attributes
         }
         data = supabase.table(table).insert(obj).execute()
      else:
         obj = data[0]
         obj['playcount'] += 1
         data = supabase.table(table).update(obj).execute()
      assert len(data.get("data", [])) > 0
      ref = data.get("data", [])
      print(ref)
      ref = ref[0] 
      os.system('clear')
      print(
         [a['name'] for a in song['artists']],
         '-',
         ref['name'],
         '(',
         ref['playcount'],
         ')')
      
      last = sid
      with open(fn, 'w') as f:
         f.write(last)
      sleep(1)