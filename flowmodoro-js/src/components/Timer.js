import React, { useEffect, useState } from "react";
import styled from "styled-components";

import EdiText from "react-editext";
import useSound from "use-sound";

import startSfx from "../assets/sounds/me-too-603.mp3";
import endSfx from "../assets/sounds/pristine-609.mp3";
import breakEndWarningSfx from "../assets/sounds/hold-on-560.mp3";
import resetSfx from "../assets/sounds/come-to-daddy-511.mp3";
import TimeDisplay from "./TimeDisplay";
import Button from "./Button";
import Arc from "./Arc";
import { COLORS } from "../constants";

function Timer() {
    const pomodoroDurationSec = 25 * 60;
    const shortBreakTimeSec = 5 * 60;
    const breakRatio = Math.ceil(pomodoroDurationSec / shortBreakTimeSec);
    const longBreakTimeSec = 15 * 60;

    const [focusTimeSec, setFocusTime] = useState(pomodoroDurationSec);
    const [breakTimeSec, setBreakTime] = useState(0);
    const [isCounting, setIsCounting] = useState(false);
    const [isFocus, setIsFocus] = useState(false);
    const [pomCount, setPomCount] = useState(0);
    const [cloverCount, setCloverCount] = useState(0);
    const [lastTickTime, setLastTickTime] = useState(0);

    const [flowNotes, setFlowNotes] = useState("Flow Notes");

    // FIXME: Make sound functions async so they don't halt the timer
    const [playStartHook] = useSound(startSfx);
    const [playEndHook] = useSound(endSfx);
    const [playBreakEndWarningHook] = useSound(breakEndWarningSfx);
    const [playResetHook] = useSound(resetSfx);

    async function playEndSfx() {
        playEndHook();
    }

    async function playStartSfx() {
        playStartHook();
    }

    async function playBreakEndWarningSfx() {
        playBreakEndWarningHook();
    }

    async function playResetSfx() {
        playResetHook();
    }

    function toggleFocus() {
        if (!isCounting) {
            // This is the first run after a reset
            setIsCounting(true);
            setPomCount(0);
            setCloverCount(0);
            playStartSfx();
        }

        setIsFocus(!isFocus);
    }

    function reset() {
        setFocusTime(pomodoroDurationSec);
        setBreakTime(0);
        setIsFocus(false);
        setIsCounting(false);
        setLastTickTime(0);
        playResetSfx();
    }

    function getElapsed() {
        if (lastTickTime === 0) {
            setLastTickTime(Date.now());
            console.log(lastTickTime);
            console.log(0);
            return 1;
        }

        let elapsed = Math.round((Date.now() - lastTickTime) / 1000);
        console.log(elapsed + " sec elapsed");
        setLastTickTime(Date.now());
        return elapsed;
    }

    useEffect(() => {
        let interval = null;

        if (isCounting && isFocus) {
            // In a focus session
            interval = setInterval(() => {
                let elapsed = getElapsed();

                let newFocusTime = focusTimeSec - elapsed;

                for (const i of Array(elapsed).keys()) {
                    let testTime = focusTimeSec - i;
                    if (testTime % breakRatio === 0) {
                        setBreakTime((seconds) => seconds + 1);
                    }
                }

                if (newFocusTime <= 0) {
                    // Completed a Pom
                    let newPomCount = pomCount + 1;
                    setPomCount(newPomCount);
                    playEndSfx();
                    if (newPomCount % 4 === 0) {
                        // Completed a Clover
                        setCloverCount((count) => count + 1);
                        setBreakTime((seconds) => seconds + longBreakTimeSec);
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
                let elapsed = getElapsed();

                setBreakTime((seconds) => seconds - elapsed);

                if (breakTimeSec === 10) {
                    playBreakEndWarningSfx();
                }

                // TODO: Maybe give a bit of leeway with break time?
                if (breakTimeSec <= 0) {
                    reset();
                }
            }, 1000);
        } else if (!isCounting) {
            // Reset
            clearInterval(interval);
        }
        return () => clearInterval(interval);
    }, [
        isCounting,
        isFocus,
        focusTimeSec,
        breakTimeSec,
        longBreakTimeSec,
        breakRatio,
        pomodoroDurationSec,
        pomCount,
        lastTickTime,
        reset,
    ]);

    return (
        <Wrapper>
            <Button
                isActive={isFocus}
                activeText="break."
                inactiveText="focus."
                onClick={toggleFocus}
            />
            <TimeDisplay seconds={focusTimeSec} variant="primary" />
            <TimeDisplay seconds={breakTimeSec} variant="secondary" />
            <Arc
                color={COLORS.burgundy}
                radius={600}
                startAngleDeg={0}
                endAngleDeg={
                    ((pomodoroDurationSec - focusTimeSec) /
                        pomodoroDurationSec) *
                    360
                }
            />
            <Arc
                color={COLORS.purple}
                radius={588}
                startAngleDeg={
                    breakTimeSec >= pomodoroDurationSec
                        ? -359.99
                        : (breakTimeSec / pomodoroDurationSec) * -360
                }
                endAngleDeg={0}
            />
            <p>
                {pomCount} ||| {cloverCount}
            </p>
        </Wrapper>
    );
}

// TODO: Sectioned circles and cool pom archive display

const Wrapper = styled.div`
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    min-height: 100%;
`;

export default Timer;