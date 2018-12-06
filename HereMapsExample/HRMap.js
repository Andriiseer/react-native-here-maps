import React, {Component} from 'react';
import { requireNativeComponent, NativeModules, } from 'react-native';
import PropTypes from 'prop-types';


class MainHRMap extends React.Component{
    constructor(props){
        super(props);
        
    }
    static propTypes = {
        InitCoords: PropTypes.object,
        routeParams: PropTypes.object,
    }

 
    render() {
        return (
                <HRMap 
                {...this.props} 
                />
        );
      };
};


var HRMap = requireNativeComponent('HRMap', MainHRMap);

module.exports  =  MainHRMap;