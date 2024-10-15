import { createRouter, createWebHistory } from 'vue-router';
import Dashboard from '@/views/Dashboard.vue';
import ManageWorkingTime from '@/views/ManageWorkingTime.vue';
import ManageProfile from '@/views/ManageProfile.vue';

const routes = [
	{ path: '/', component: Dashboard },
	{ path: '/profile', component: ManageProfile },
	{ path: '/manage', component: ManageWorkingTime },
];

const router = createRouter({
	history: createWebHistory(),
	routes
});

export default router;

