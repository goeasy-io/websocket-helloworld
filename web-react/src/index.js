import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';
import reportWebVitals from './reportWebVitals';

import GoEasy from 'goeasy'

const goEasy = GoEasy.getInstance({
  host: 'hangzhou.goeasy.io',//应用所在的区域地址: 【hangzhou.goeasy.io |singapore.goeasy.io】
  appkey: 'BC-xxxx',
  modules: ['pubsub'],
});

window.goEasy = goEasy;

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <App/>
);

reportWebVitals();
