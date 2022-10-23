import App from './App.svelte';
import './scss/style.scss';

const app = new App({
	target: document.querySelector('#proj-container'),
	props: {
		'title': 'Star Tribune Svelte 3 app'
	}
});

window.app = app;

export default app;
