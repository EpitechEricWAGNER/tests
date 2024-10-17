<script setup lang="ts">
import { computed, onMounted, reactive } from "vue";
import clockService from "@/services/clockService";
import { useStore } from "vuex";

const store = useStore();
const user = computed(() => store.getters.user);

let clockIn: string[] = [];
let clockOut: string[] = [];

const workTime = reactive({
    hours: 0,
    minutes: 0,
});

const getClockForToday = async () => {
    try {
        const id = user.value.data.id;
        const clockData = {
            time: new Date().toISOString().split("T")[0],
            status: false,
            user: id,
        };
        const clockResponse = await clockService.getClocks(clockData);
        const clockList = clockResponse.data;
        for (let i = 0; i < clockList.length; i++) {
            if (clockList[i].status) {
                clockIn.push(clockList[i].time);
            } else {
                clockOut.push(clockList[i].time);
            }
        }
        calculateTimeWork();
    } catch (error) {
        console.error("Error while fetching clock for today:", error);
    }
};

const calculateTimeWork = () => {
    let totalMinutes = 0;
    for (let i = 0; i < clockOut.length; i++) {
        let clockOutHour = parseInt(clockOut[i].split(":")[0]);
        let clockOutMinute = parseInt(clockOut[i].split(":")[1]);
        let clockInHour = parseInt(clockIn[i].split(":")[0]);
        let clockInMinute = parseInt(clockIn[i].split(":")[1]);
        let diffHour = clockOutHour - clockInHour;
        let diffMinute = clockOutMinute - clockInMinute;
        totalMinutes += diffHour * 60 + diffMinute;
    }
    workTime.hours = Math.floor(totalMinutes / 60);
    workTime.minutes = totalMinutes % 60;
};

onMounted(() => {
    if (user.value) {
        getClockForToday();
    }
});
</script>

<template>
    <div class="text-2xl font-bold">
        {{ workTime.hours }} hours {{ workTime.minutes }} minutes
    </div>
</template>
