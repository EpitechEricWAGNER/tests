import { createRouter, createWebHistory } from 'vue-router';
import Dashboard from '@/views/Dashboard.vue';
import Manage from '@/views/Manage.vue';

const routes = [
	{ path: '/', component: Dashboard },
	{ path: '/manage', component: Manage },
];

const router = createRouter({
	history: createWebHistory(),
	routes
});

export default router;

