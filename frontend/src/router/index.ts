import { createRouter, createWebHistory } from "vue-router";
import Dashboard from "@/views/Dashboard.vue";
import Manage from "@/views/Manage.vue";
import CreateUserForm from "@/components/CreateUserForm.vue";
import ProfileForm from "@/components/ProfileForm.vue";

const routes = [
    { path: "/", component: Dashboard },
    {
        path: "/manage",
        component: Manage,
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
];

const router = createRouter({
    history: createWebHistory(),
    routes,
});

export default router;
