import React from "react";
import PropTypes from "prop-types";
import styled from "styled-components";
import Arc from "./Arc";
import { COLORS } from "../constants";

function SectionedCircle(props) {
    function createArcs(data) {
        if (data.length == 0) {
            return [];
        }
        let totalTime = 0;
        totalTime = data.reduce((a, b) => a + b);

        let startDeg = 0;
        let endDeg = 0;

        let isFocus = true; // Assume that the first elem of any circle is focus b/c baked into timer logic

        let result = [];

        data.forEach((arcLen) => {
            endDeg = startDeg + (arcLen / totalTime) * 360;

            // Hack: 360 counts as 0 :()
            if (endDeg == 360) {
                endDeg = 359.99;
            }
            result.push(
                <Arc
                    radius={props.radius}
                    startAngleDeg={startDeg}
                    endAngleDeg={endDeg}
                    color={isFocus ? COLORS.burgundy : COLORS.purple}
                />
            );

            startDeg = endDeg;
            isFocus = !isFocus;
        });

        return result;
    }

    const arcs = createArcs(props.data);

    return <Wrapper dims={props.radius + "px"}>{arcs}</Wrapper>;
}

SectionedCircle.propTypes = {
    radius: PropTypes.number,
    data: PropTypes.arrayOf(PropTypes.number),
};

const Wrapper = styled.div`
    display: inline;
    position: relative;
    width: ${(props) => props.dims};
    height: ${(props) => props.dims};
`;

export default SectionedCircle;
