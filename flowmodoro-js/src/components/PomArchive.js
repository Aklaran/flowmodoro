import React from "react";
import PropTypes from "prop-types";
import SectionedCircle from "./SectionedCircle";
import styled from "styled-components";

function PomArchive(props) {
    function extractCircles(timeBlocks, pomIndices) {
        let result = [];

        let prevIndex = 0;
        pomIndices.forEach((index) => {
            result.push(timeBlocks.slice(prevIndex, index + 1));
            prevIndex = index + 1;
        });
        return result;
    }

    const circleData = extractCircles(props.timeBlocks, props.pomIndices);

    return (
        <Wrapper>
            {circleData.map((circle) => (
                <SectionedCircle data={circle} radius={50} />
            ))}
        </Wrapper>
    );
}

PomArchive.propTypes = {
    timeBlocks: PropTypes.arrayOf(PropTypes.number),
    pomIndices: PropTypes.arrayOf(PropTypes.number),
};

const Wrapper = styled.div`
    position: relative;
    display: flex;
    flex-direction: row;
    justify-content: center;
    width: 400px;
    flex-wrap: wrap;
    margin-top: 30px;
`;

export default PomArchive;
