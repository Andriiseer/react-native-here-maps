import React from 'react';
import { StyleSheet, Text, View, TouchableOpacity } from 'react-native';
import MainHRMap from './HRMap.js';
import {NativeModules} from 'react-native';
let HEREMap = NativeModules.HRMapManager;
const sleep = ms => new Promise(resolve => setTimeout(resolve, ms));


export default class App extends React.Component {
    constructor(props){
        super(props);
        this.state={
            routeParams: {
                OriginLat: 0,
                OriginLng: 0,
                DestinationLat: 0,
                DestinationLng: 0
            },
            initCoords: {
                Lat: 40.668727,
                Lng: -73.992850
            },
            ButtonText: 'Create Route'
        }
        this.createRoute = this.createRoute.bind(this);
    }
    
    createRoute(){
        if (this.state.ButtonText !== 'Navigate') {
            this.setState({
                routeParams: {
                    OriginLat: 40.668727,
                    OriginLng: -73.992850,
                    DestinationLat: 41.070640,
                    DestinationLng: -71.860219
                }, 
                ButtonText: 'Navigate'
            })
        } else {
             sleep(100).then(()=>HEREMap.Action('Navigate'));
        }
        
        
    }
    
    render() {
        return (
          <View style={styles.container}>

            <MainHRMap 

                        InitCoords={this.state.initCoords}
                        routeParams={this.state.routeParams}

                        style={{justifyContent: 'center',
                        alignItems: 'center',
                        backgroundColor: '#FF0000',
                        height: 400,
                        width: 400}}

                    />
            <TouchableOpacity style={styles.button} onPress={this.createRoute}><Text>{this.state.ButtonText}</Text></TouchableOpacity>
          </View>
        );
      }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
  button: {
      width: 200,
      height: 30,
      backgroundColor: '#ccc',
      alignItems: 'center',
      justifyContent: 'center' 
  }
});
