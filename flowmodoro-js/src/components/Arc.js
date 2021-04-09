import React from "react";
import PropTypes from "prop-types";
import { COLORS } from "../constants";
import styled from "styled-components";

function Arc(props) {
    const centerPoint = props.radius / 2;
    const strokeWidth = 5;
    return (
        <SvgArc dims={props.radius + "px"}>
            <path
                fill="none"
                stroke={props.color}
                stroke-width={strokeWidth}
                d={describeArc(
                    centerPoint,
                    centerPoint,
                    props.radius / 2 - strokeWidth,
                    props.startAngleDeg,
                    props.endAngleDeg
                )}
            />
        </SvgArc>
    );
}

Arc.propTypes = {
    radius: PropTypes.number,
    startAngleDeg: PropTypes.number,
    endAngleDeg: PropTypes.number,
    color: PropTypes.string,
};

const SvgArc = styled.svg`
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    width: ${(props) => props.dims};
    height: ${(props) => props.dims};
    margin: auto;
    pointer-events: none;
`;

export default Arc;

/*
    Arc drawing from https://stackoverflow.com/questions/5736398/how-to-calculate-the-svg-path-for-an-arc-of-a-circle
*/

function polarToCartesian(centerX, centerY, radius, angleInDegrees) {
    var angleinRadians = ((angleInDegrees - 90) * Math.PI) / 180.0;
    return {
        x: centerX + radius * Math.cos(angleinRadians),
        y: centerY + radius * Math.sin(angleinRadians),
    };
}

function describeArc(x, y, radius, startAngle, endAngle) {
    var start = polarToCartesian(x, y, radius, endAngle);
    var end = polarToCartesian(x, y, radius, startAngle);

    var largeArcFlag = endAngle - startAngle <= 180 ? "0" : "1";

    return [
        "M",
        start.x,
        start.y,
        "A",
        radius,
        radius,
        0,
        largeArcFlag,
        0,
        end.x,
        end.y,
    ].join(" ");
}
