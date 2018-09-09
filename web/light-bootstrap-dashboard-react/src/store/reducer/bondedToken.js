import * as actionTypes from '../actions/actionTypes';
import { updateObject } from '../utility'


const initialState = {
    totalSupply: null
};

const setSupply = (state, action) => {
    return updateObject(state, { totalSupply: action.totalSupply })
}

const reducer = (state = initialState, action) => {
    switch (action.type) {
        case actionTypes.SET_SUPPLY: return setSupply(state, action);
    }
};

export default reducer;