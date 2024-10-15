import { createStore } from 'vuex';
import createPersistedState from 'vuex-persistedstate';

export interface User {
	id: string;
	username: string;
	email: string;
}

interface State {
	user: User | null; // L'utilisateur peut être null ou un objet User
}

const store = createStore<State>({
	plugins: [createPersistedState()],
	state: {
		user: null,
	},
	mutations: {
		setUser(state, user: User) {
			console.log('Mise à jour du store avec l\'utilisateur:', user);
			state.user = user;
		},
		clearUser(state) {
			state.user = null;
		},
	},
	getters: {
		user(state): User | null {
			return state.user;
		},
	},
});

export default store;
