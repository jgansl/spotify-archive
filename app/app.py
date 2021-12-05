# laod variables - gernes, years
# kclusteirn in each genre - folk
# only songs not yet in genre

# https://towardsdatascience.com/advanced-streamlit-session-state-and-callbacks-for-data-labelling-tool-1e4d9ad32a3f
import streamlit as st # https://docs.streamlit.io/library/api-reference/widgets/st.button
from streamlit_autorefresh import st_autorefresh
count = st_autorefresh(interval=1000, limit=None, key="count")
from pydash import flatten

# https://docs.streamlit.io/library/api-reference/session-state
if 'key' not in st.session_state:
    st.session_state['key'] = 'value'
# if 'key' not in st.session_state:
#     st.session_state.key = 'value'

genres = [
   'Dance/Electronic'
   'Folk & Acoustic',
   'Hip Hop',
   'Indie',
   'Latin',
   'Lofi/Bedroom Pop',
   # 'Rock',
   'R&B',
   'No Genre',
   'Test' #Not sorted - 
]

years = [
   '2021',
   '2020',
   '2015',
   '2010',
   '00s',
   '90s',
   '80s',
   '70s'
]

def assign(sid, genre):
   # move()
   print(sid)
   print(genre)
   pass

res = sp.currently_playing()
song = res['item'] #autoreaload

st.markdown("![Alt Text]("+song['album']['images'][0]['url']+")") #[image]
st.write(song['name'])
st.write(','.join([a['name'] for a in song['arists']]))
cols = flatten(sp.artists(song['id'])

cols = st.columns(len(genres))
for i,genre in enumerate(genres):
   cols[i].button(genre, key=genre, on_click=assign, args=(), kwargs={'sid':'a', 'genre':genre})

# if st.button('Say hello'): 
#    st.write('Why hello there')
# else:
#    st.write('Goodbye')