<script setup lang="ts">
import { Button } from "@/components/ui/button";
import { computed, onMounted } from "vue";
import clockService from "@/services/clockService";
import { useStore } from "vuex";
import { ref } from "vue";

const store = useStore();
const user = computed(() => store.getters.user);
const statusBtn = ref(false); // Représente l'état visuel du bouton (clock in ou clock out)

const clockData = ref({
    time: new Date().toISOString().split("T")[0],
    status: false,
    user: user.value ? user.value.data.id : null,
});

const getClock = async () => {
    try {
        const response = await clockService.getClocks(clockData.value);
        const clocks = response.data;

        if (clocks && clocks.length > 0) {
            // Récupère le dernier état
            const lastClock = clocks[clocks.length - 1];
            statusBtn.value = lastClock.status; // Met à jour l'état du bouton
            clockData.value.status = lastClock.status; // Met à jour l'état dans clockData
        } else {
            // Aucune clock trouvée, peut-être que c'est la première fois
            statusBtn.value = false;
        }
        return clocks;
    } catch (error) {
        console.error("Erreur lors de la récupération de l'horloge:", error);
        return null;
    }
};

const createClock = async () => {
    try {
        statusBtn.value = !statusBtn.value;
        clockData.value.status = statusBtn.value;
        clockData.value.time = new Date().toISOString();

        console.log("clockData envoyé:", clockData.value);
        // Appel à l'API pour créer une nouvelle clock
        await clockService.clock(clockData.value);
    } catch (error) {
        console.error("Erreur lors de la création de l'horloge:", error);
    }
};

onMounted(() => {
    if (user.value !== null && user.value !== undefined && user.value !== "") {
        getClock();
    }
});
</script>

<template>
    <Button
        :class="[statusBtn ? 'bg-green-500 hover:bg-green-700' : 'bg-red-500 hover:bg-red-700']"
        @click="createClock"
    >
        {{ statusBtn ? 'Clock Out' : 'Clock In' }}
    </Button>
</template>

