import React, { useEffect, useState } from 'react';
import EdiText from 'react-editext';
import useSound from 'use-sound';

import '../css/App.css';
import startSfx from '../../assets/sounds/me-too-603.mp3';
import endSfx from '../../assets/sounds/pristine-609.mp3';
import breakEndWarningSfx from '../../assets/sounds/hold-on-560.mp3';
import resetSfx from '../../assets/sounds/come-to-daddy-511.mp3';

function App() {
  const pomodoroDurationSec = 25 * 60;
  const shortBreakTimeSec = 5 * 60;
  const breakRatio = Math.ceil(pomodoroDurationSec / shortBreakTimeSec);
  const longBreakTimeSec = 15 * 60;

  const [focusTimeSec, setFocusTime] = useState(pomodoroDurationSec);
  const [breakTimeSec, setBreakTime] = useState(13);
  const [isCounting, setIsCounting] = useState(false);
  const [isFocus, setIsFocus] = useState(false);
  const [pomCount, setPomCount] = useState(0);
  const [cloverCount, setCloverCount] = useState(0);

  const [flowNotes, setFlowNotes] = useState('Flow Notes');

  // FIXME: Make sound functions async so they don't halt the timer
  const [playStartSfx] = useSound(startSfx);
  const [playEndSfx] = useSound(endSfx);
  const [playBreakEndWarningSfx] = useSound(breakEndWarningSfx);
  const [playResetSfx] = useSound(resetSfx);

  function toggleFocus() {
    if (!isCounting) {
      // This is the first run after a reset
      setIsCounting(true);
      setPomCount(0);
      setCloverCount(0);
      playStartSfx();
    }
    if (isFocus) {
      setFocusTime(pomodoroDurationSec);
    }
    setIsFocus(!isFocus);
  }

  function reset() {
    setFocusTime(pomodoroDurationSec);
    setBreakTime(0);
    setIsFocus(false);
    setIsCounting(false);
    playResetSfx();
  }

  useEffect(() => {
    let interval = null;

    if (isCounting && isFocus) {
      // In a focus session
      interval = setInterval(() => {
        let newFocusTime = focusTimeSec - 1
        if (newFocusTime % breakRatio === 0) {
          setBreakTime(seconds => seconds + 1);
        }

        if (newFocusTime === 0) {
          // Completed a Pom
          let newPomCount = pomCount + 1;
          setPomCount(newPomCount);
          playEndSfx();
          if (newPomCount % 4 === 0) {
            // Completed a Clover
            setCloverCount(count => count + 1)
            setBreakTime(seconds => seconds + longBreakTimeSec)
          }
          setFocusTime(pomodoroDurationSec);
        } else {
          // Normal execution
          setFocusTime(newFocusTime);
        }
      }, 1000);
    } else if (isCounting && !isFocus) {
      // In a break session
      interval = setInterval(() => {
        setBreakTime(seconds => seconds - 1);

        if (breakTimeSec === 10) {
          playBreakEndWarningSfx();
        }

        // TODO: Maybe give a bit of leeway with break time?
        if (breakTimeSec === 0) {
          reset();
        }
      }, 1000);
    } else if (!isCounting) {
      // Reset
      clearInterval(interval);
    }
    return () => clearInterval(interval);
  }, [isCounting, isFocus, focusTimeSec, breakTimeSec, longBreakTimeSec, breakRatio, pomodoroDurationSec, pomCount, reset]);

  return (
    <div className="App">
      <header className="App-header">
        <h1>Flowmodoro!</h1>
        <span>Focus: {Math.floor(focusTimeSec / 60)}m {focusTimeSec % 60}s</span>
        <span>Break: {Math.floor(breakTimeSec / 60)}m {breakTimeSec % 60}s</span>
        <span>---</span>
        <span>Poms: {pomCount}</span>
        <span>Clovers: {cloverCount}</span>
        <button className={`button button-primary button-primary-${isFocus ? 'active' : 'inactive'}`} onClick={toggleFocus}>
          {isFocus ? 'Break' : 'Focus'}
        </button>
        <button className="button" onClick={reset}>
          Reset
        </button>
        <EdiText
          submitOnEnter
          cancelOnEscape
          editOnViewClick={true}
          viewContainerClassName='my-custom-view-wrapper'
          type="text"
          inputProps={{
            rows: 5
          }}
          saveButtonContent='Apply'
          cancelButtonContent={<strong>Cancel</strong>}
          editButtonContent='Edit Flow Notes'
          value={flowNotes}
          onSave={setFlowNotes}
        />
      </header>
    </div>
  );
}

export default App;
