import { createRouter, createWebHistory } from "vue-router";
import Dashboard from "@/views/Dashboard.vue";
import ManageWorkingTime from '@/views/ManageWorkingTime.vue';
import ManageProfile from "@/views/ManageProfile.vue";
import CreateUserForm from "@/components/CreateUserForm.vue";
import ProfileForm from "@/components/ProfileForm.vue";

const routes = [
    { path: "/", component: Dashboard },
	{
        path: "/profile",
        component: ManageProfile,
        children: [
            {
                path: "create",
                component: CreateUserForm,
            },
            {
                path: "",
                component: ProfileForm,
            },
        ],
    },
	{ path: '/manage', component: ManageWorkingTime },
];

const router = createRouter({
    history: createWebHistory(),
    routes,
});

export default router;
