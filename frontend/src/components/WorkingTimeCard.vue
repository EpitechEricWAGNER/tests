<script setup lang="ts">
import { computed, onMounted, watch } from "vue";
import clockService from "@/services/clockService";
import { useStore } from "vuex";
import { ref } from 'vue'

const store = useStore();
const user = computed(() => store.getters.user);

const userId = ref<string>('');
const username = ref<string>('');
const email = ref<string>('');
userId.value = user ? user.value.data.id : '';

watch(user, (newUser: any) => {
  userId.value = newUser.data.id;
  username.value = newUser.data.username;
  email.value = newUser.data.email;
})

import { workingtimeService } from "@/services/workingtimeService";
const selectedDates = ref({
  startDateRange: null,
  endDateRange: null
})

function handleDateChange(dates: { startDateRange: Date, endDateRange: Date }) {
  selectedDates.value = dates
  
  store.commit('setDateRange', selectedDates);
  console.log('Date range changed:', dates)
}
const formatValue = (val) => val.toString().padStart(2, '0');

const currentMonthStart = new Date(new Date().getFullYear(), new Date().getMonth(), 1);
const currentMonthEnd = new Date(new Date().getFullYear(), new Date().getMonth() + 1, 0);
const currentMonthStartString = currentMonthStart.getFullYear() + "-" + (formatValue(currentMonthStart.getMonth() + 1)) + "-" + formatValue(currentMonthStart.getDate()) + " 00:00:00";

const currentMonthEndString = currentMonthEnd.getFullYear() + "-" + (formatValue(currentMonthEnd.getMonth() + 1)) + "-" + formatValue(currentMonthEnd.getDate()) + " 23:59:59";

const workingTimes = ref([]);
const getWorkingTimes = async () => {
  if (!userId.value || !currentMonthStartString || !currentMonthEndString) {
    console.error("Missing required parameters for request");
    return;
  }
  try {
    const response = await workingtimeService.getAllWorkingTimes(userId.value, currentMonthStartString, currentMonthEndString);
    workingTimes.value = response.data;
  } catch (error) {
    console.error("Error fetching working times:", error);
  }
};
getWorkingTimes();

const calculateDuration = (start: Date, end: Date) => {
  const startTime = new Date(start);
  const endTime = new Date(end);
  return (endTime.getHours() - startTime.getHours()) * 60 +
         (endTime.getMinutes() - startTime.getMinutes());
};

const calculateTotalHours = () => {
    let total = 0;
    workingTimes.value.forEach((work) => {
        const duration = calculateDuration(new Date(work.start), new Date(work.end));
        total += duration;
    });
    return total;
};

let totalHours = ref(0);
watch(workingTimes, () => {
    totalHours.value = calculateTotalHours();
});
</script>

<template>
    <div class="text-2xl font-bold">
        <div v-if="totalHours == 0">
            No Work
        </div>
        <div v-else>
            {{ Math.floor(totalHours / 60) }} hours {{ totalHours % 60 }} minutes
        </div>
    </div>
</template>
