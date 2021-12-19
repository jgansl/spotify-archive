limport os
from supabase import create_client, Client
#import typing
import json
from spotify_base import SpotifyClient
SpotifyClient()
 # https://keosariel.github.io/2021/08/08/supabase-client-python/
url: str = os.environ.get("SUPABASE_URL") or 'https://isilsfihozvjwehjnbjh.supabase.co'
key: str = os.environ.get("SUPABASE_KEY") or 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoic2VydmljZV9yb2xlIiwiaWF0IjoxNjI3NTA4ODk3LCJleHAiOjE5NDMwODQ4OTd9.L0V60RzDyfgHE2hDGc0Ejjc9xwqOwGY3ut28eyeoWtQ'
#'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYyNzUwODg5NywiZXhwIjoxOTQzMDg0ODk3fQ.6hmZYC7aJkEywUVFA2rObTvC-fa3bXhzD7oa2STbYNE'
#'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoic2VydmljZV9yb2xlIiwiaWF0IjoxNjI3NTA4ODk3LCJleHAiOjE5NDMwODQ4OTd9.L0V60RzDyfgHE2hDGc0Ejjc9xwqOwGY3ut28eyeoWtQ'
supabase: Client = create_client(url, key)

# insert
table = "tracks"
# data = supabase.table(table).delete(
#    {
#       "sid":"test",
#       "name":"Germany",
#       "playcount": 0
#    }
# ).execute()

# data = supabase.table(table).select("*" #col: "sid"
#    # {
#    #    "sid":"test",
#    # }
#    # Filters
#     # .eq('column', 'Equal to')
#     # .gt('column', 'Greater than')
#     # .lt('column', 'Less than')
#     # .gte('column', 'Greater than or equal to')
#     # .lte('column', 'Less than or equal to')
#     # .like('column', '%CaseSensitive%')
#     # .ilike('column', '%CaseInsensitive%')
#     # .neq('column', 'Not equal to')
# ).eq('name', 'test').get('data').delete().execute()

#assert len(data.get("data", [])) > 0
# Assert we pulled real data.

#del
# error, result = #await (
# error, result = supabase.table(table).delete(id=37)
#)
# e,r = supabase.table(table).delete().execute()
# print(e)
# print(r)
res = supabase.table(table).select("*").execute()
data = res.get("data", [])
jprint = lambda x: print(json.dumps(x, indent=2))
jprint(len(data))

# realtime change
# subscription = supabase
#   .table('countries')
#   .on('*',  lambda x: print(x))
#   .subscribe()

eradef delete(sid, id=None):
   return

#flutter