import React from "react";
import PropTypes from "prop-types";
import styled from "styled-components";

function TimeDisplay(props) {
  const minutes = Math.floor(props.seconds / 60);
  const seconds = ("0" + (props.seconds % 60)).slice(-2);

  return (
    <Display>
      {minutes}:{seconds}
    </Display>
  );
}

TimeDisplay.propTypes = {
  seconds: PropTypes.number,
};

const Display = styled.p`
  font-family: SquareSans;
  font-size: 3rem;
  transform: scale(0.75, 1);
`;

const STYLES = {
  primary: {},
  secondary: {},
};

export default TimeDisplay;
