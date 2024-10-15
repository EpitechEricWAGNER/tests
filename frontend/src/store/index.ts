import { createStore } from 'vuex';
import createPersistedState from 'vuex-persistedstate';

export interface User {
	id: string;
	username: string;
	email: string;
}

export interface DateRange {
	startDateRange: string;
	endDateRange: string;
}

interface State {
	user: User | null; // L'utilisateur peut être null ou un objet User
	dateRange: DateRange; // La plage de dates peut être null ou un objet DateRange
}

const store = createStore<State>({
	plugins: [createPersistedState()],
	state: {
		user: null,
		dateRange: { startDateRange: '', endDateRange: '' },
	},
	mutations: {
		setUser(state, user: User) {
			console.log('Mise à jour du store avec l\'utilisateur:', user);
			state.user = user;
		},
		clearUser(state) {
			state.user = null;
		},
		setDateRange(state, dateRange: DateRange) {
			console.log('Mise à jour du store avec la plage de dates:', dateRange);
            state.dateRange = dateRange;
        },
		clearDateRange(state) {
            state.dateRange = { startDateRange: '', endDateRange: '' };
        },
	},
	getters: {
		user(state): User | null {
			return state.user;
		},
		dateRange(state): DateRange {
            return state.dateRange;
        },
	},
});

export default store;
