import { useEffect, useState, useMemo, useRef } from "react";
import logo from "./logo.svg";
import "./App.css";
import WebPlayback from "./components/playback";

interface StrInputProps {
  device_id?: string;
  message?: string;
}

function App() {
  return (
    <div className="App">
      <h1>Hello CodeSandbox</h1>
      <WebPlayback />
    </div>
  );
}

export default App;
