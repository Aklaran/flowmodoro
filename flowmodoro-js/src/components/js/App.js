import React, { useEffect, useState } from 'react';
import '../css/App.css';

function App() {
  const pomodoroDurationSec = 25;
  const shortBreakTimeSec = 5;
  const breakRatio = Math.ceil(pomodoroDurationSec / shortBreakTimeSec);
  const longBreakTimeSec = 10 * 60;

  const [focusTimeSec, setFocusTime] = useState(pomodoroDurationSec);
  const [breakTimeSec, setBreakTime] = useState(0);
  const [isActive, setIsActive] = useState(false);

  function toggle() {
    setIsActive(!isActive);
  }

  function reset() {
    setFocusTime(pomodoroDurationSec);
    setBreakTime(0);
    setIsActive(false);
  }

  useEffect(() => {
    let interval = null;
    if (isActive) {
      interval = setInterval(() => {
        setFocusTime(seconds => seconds - 1);
        if (focusTimeSec % breakRatio === 1) {
          setBreakTime(seconds => seconds + 1);
        }
      }, 1000);
    } else if (!isActive && breakTimeSec !== 0) {
      clearInterval(interval);
    }
    return () => clearInterval(interval);
  }, [isActive, focusTimeSec, breakTimeSec, breakRatio]);

  return (
    <div className="App">
      <header className="App-header">
        <h1>Wtf is Javascript even...</h1>
        <span>Focus: {focusTimeSec}s</span>
        <span>Break: {breakTimeSec}s</span>
        <button className={`button button-primary button-primary-${isActive ? 'active' : 'inactive'}`} onClick={toggle}>
          {isActive ? 'Pause' : 'Start'}
        </button>
        <button className="button" onClick={reset}>
          Reset
        </button>
      </header>
    </div>
  );
}

export default App;
