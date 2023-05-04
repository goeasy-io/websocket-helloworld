/**
 * @format
 */

import {AppRegistry,Platform} from 'react-native';
import App from './App';
import {name as appName} from './app.json';

import AsyncStorage from '@react-native-async-storage/async-storage'

import GoEasy from "goeasy";

const goEasy = GoEasy.getInstance({
    host:"hangzhou.goeasy.io",//应用所在的区域地址: 【hangzhou.goeasy.io |singapore.goeasy.io】
    appkey:"BC-xxxx",// common key
    modules: ['pubsub'],
    reactNativeOptions: {
        platform: Platform,
        asyncStorage: AsyncStorage
    }
});
global.goEasy = goEasy;

AppRegistry.registerComponent(appName, () => App);
