// Polyfills
import 'es6-object-assign/auto';
import 'core-js/fn/array/includes';
import 'core-js/fn/promise/finally';
import 'intl'; // For Safari 9

import React from 'react';
import ReactDOM from 'react-dom';

import AppStateHOC from '../lib/app-state-hoc.jsx';
import BrowserModalComponent from '../components/browser-modal/browser-modal.jsx';
import supportedBrowser from '../lib/supported-browser';

import styles from './index.css';

if (typeof window !== 'undefined') {
    if (process.env.LML_ALGO_MODE) {
        window.LML_ALGO_MODE = process.env.LML_ALGO_MODE;
        window.localStorage?.setItem('LML_ALGO_MODE', process.env.LML_ALGO_MODE);
    }
    if (process.env.LML_ALGO_BASE_URL) {
        window.LML_ALGO_BASE_URL = process.env.LML_ALGO_BASE_URL;
        window.localStorage?.setItem('LML_ALGO_BASE_URL', process.env.LML_ALGO_BASE_URL);
    }
}

const appTarget = document.createElement('div');
appTarget.className = styles.app;
document.body.appendChild(appTarget);

if (supportedBrowser()) {
    // require needed here to avoid importing unsupported browser-crashing code
    // at the top level
    require('./render-gui.jsx').default(appTarget);

} else {
    BrowserModalComponent.setAppElement(appTarget);
    const WrappedBrowserModalComponent = AppStateHOC(BrowserModalComponent, true /* localesOnly */);
    const handleBack = () => {};
    // eslint-disable-next-line react/jsx-no-bind
    ReactDOM.render(<WrappedBrowserModalComponent onBack={handleBack} />, appTarget);
}
