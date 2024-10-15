<script setup lang="ts">
import { RouterLink } from "vue-router";

interface Item {
    title: string;
    href: string;
}

const sidebarNavItems: Item[] = [
    {
        title: "Create",
        href: "/profile/create",
    },
    {
        title: "Profile",
        href: "/profile",
    },
];
</script>

<template>
    <nav class="flex space-x-2 lg:flex-col lg:space-x-0 lg:space-y-1">
        <RouterLink
            v-for="item in sidebarNavItems"
            :key="item.title"
            :to="item.href"
            class="w-full text-left justify-start"
            active-class="bg-muted hover:bg-muted"
        >
            {{ item.title }}
        </RouterLink>
    </nav>
</template>
