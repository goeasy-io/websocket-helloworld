/**
 * @format
 */

import {AppRegistry} from 'react-native';
import App from './App';
import {name as appName} from './app.json';
import GoEasy from "goeasy";

const goEasy = GoEasy.getInstance({
    host:"hangzhou.goeasy.io",//应用所在的区域地址: 【hangzhou.goeasy.io |singapore.goeasy.io】
    appkey:"BC-xxxx",// common key
    modules: ['pubsub'],
});
global.goEasy = goEasy;

AppRegistry.registerComponent(appName, () => App);
