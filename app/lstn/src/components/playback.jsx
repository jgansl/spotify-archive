import React, { useState, useEffect } from "react";

const track = {
  name: "",
  album: {
    images: [{ url: "" }],
  },
  artists: [{ name: "" }],
};

function WebPlayback(props) {
  const [player, setPlayer] = useState(false);
  const [is_paused, setPaused] = useState(false);
  const [is_active, setActive] = useState(false);
  const [current_track, setTrack] = useState(track);

  useEffect(() => {
    const script = document.createElement("script");
    script.src = "https://sdk.scdn.co/spotify-player.js";
    script.async = true;

    document.body.appendChild(script);

    window.onSpotifyWebPlaybackSDKReady = () => {
      const token =
        "BQC2sqrU4_XTh2kdLDsXP0gOH5sZbY6OLhAhkfSViyMkTatxvUU-7FC-brlI2rM7gMsZlZdx2bLPsnd9R9igGefUUnPU_hYv5JvQLgQuhsB7_6aw2zpRLhohDJJN17c2KH87FDcdyhiHCHjV_ch1__popeD5qxTmycFGmFnUoZJtN7xaEajqYwZ2X7Aav1wCIHyyIa-RX0t4MUK5V7UO33C_4F-cjPhWZXyld3Zz6DZ5d0n8I0tETztIbUtMdgbkuhk1oia59V_yP6adjLrKvTLY_s4Q2NkVVpiiTSmNwbrYErljr3GP";
      const player = new Spotify.Player({
        name: "Web Playback SDK",
        getOAuthToken: (cb) => {
          cb(token); //props.token
        },
        volume: 0.5,
      });

      setPlayer(player);

      player.addListener("ready", ({ device_id }) => {
        console.log("Ready with Device ID", device_id);
      });

      player.addListener("not_ready", ({ device_id }) => {
        console.log("Device ID has gone offline", device_id);
      });

      player.addListener("player_state_changed", (state) => {
        if (!state) {
          return;
        }

        setTrack(state.track_window.current_track);
        setPaused(state.paused);

        player.getCurrentState().then((state) => {
          !state ? setActive(false) : setActive(true);
        });
      });

      player.connect();
    };
  }, []);

  return (
    <>
      <div className="container">
        <div className="main-wrapper">
          <img
            src={current_track.album.images[0].url}
            className="now-playing__cover"
            alt=""
          />

          <div className="now-playing__side">
            <div className="now-playing__name">{current_track.name}</div>

            <div className="now-playing__artist">
              {current_track.artists[0].name}
            </div>
          </div>
        </div>
      </div>
      <button
        className="btn-spotify"
        onClick={() => {
          player.previousTrack();
        }}
      >
        &lt;&lt;
      </button>

      <button
        className="btn-spotify"
        onClick={() => {
          player.togglePlay();
        }}
      >
        {is_paused ? "PLAY" : "PAUSE"}
      </button>

      <button
        className="btn-spotify"
        onClick={() => {
          player.nextTrack();
        }}
      >
        &gt;&gt;
      </button>
    </>
  );
}

export default WebPlayback;
