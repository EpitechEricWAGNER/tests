<script setup lang="ts">
import { BarChart } from '@/components/ui/chart-bar'
import { computed, ref, watch, onMounted } from 'vue'
import { workingtimeService } from "@/services/workingtimeService";
import { useStore } from 'vuex';

const store = useStore();
const user = computed(() => store.getters.user);
const userId = ref<string>(user?.value?.data?.id || '');

const currentYear = new Date().getFullYear();
const currentMonth = new Date().getMonth();
const monthNames = Array.from({ length: 12 }, (_, i) => 
  new Date(currentYear, i, 1).toLocaleString('default', { month: 'long' })
);

const formatValue = (val: number) => val.toString().padStart(2, '0');
const getMonthDays = (year: number, month: number) => {
  const first = new Date(year, month, 1);
  const firstDay = `${first.getFullYear()}-${formatValue(first.getMonth() + 1)}-${formatValue(first.getDate())} 00:00:00`;
  const last = new Date(year, month + 1, 0);
  const lastDay = `${last.getFullYear()}-${formatValue(last.getMonth() + 1)}-${formatValue(last.getDate())} 23:59:59`;
  return { firstDay, lastDay };
};

const monthlyData = monthNames.map((month, index) => {
  const { firstDay, lastDay } = getMonthDays(currentYear, index);
  return { name: month, firstDay, lastDay };
});

interface WorkingTimeChartData {
  name: string;
  minutes: any;
  time: any;
}

const fetchWorkingTimesForMonth = async (firstDay: string, lastDay: string) => {
  const response = await workingtimeService.getAllWorkingTimes(userId.value, firstDay, lastDay);
  return response.data;
};

let workingTimesChartData = ref<WorkingTimeChartData[]>([]);
const selectedPeriod = ref('month');
let data = ref();

const calculateDuration = (start: Date, end: Date) => {
  const startTime = new Date(start);
  const endTime = new Date(end);
  return (endTime.getHours() - startTime.getHours()) * 60 +
         (endTime.getMinutes() - startTime.getMinutes());
};

const getWeeksInCurrentMonth = (firstDay: string, lastDay: string) => {
  const first = new Date(firstDay);
  const last = new Date(lastDay);
  const weeks = [];

  let currentWeekStart = new Date(first);
  
  let firstWeekEnd = new Date(first);
  firstWeekEnd.setDate(firstWeekEnd.getDate() + (7 - firstWeekEnd.getDay()));

  weeks.push({
    start: first.toISOString(),
    end: firstWeekEnd > last ? last.toISOString() : firstWeekEnd.toISOString(),
  });

  currentWeekStart.setDate(firstWeekEnd.getDate() + 1);

  while (currentWeekStart <= last) {
    const currentWeekEnd = new Date(currentWeekStart);
    currentWeekEnd.setDate(currentWeekStart.getDate() + 6); 

    weeks.push({
      start: currentWeekStart.toISOString(),
      end: currentWeekEnd > last ? last.toISOString() : currentWeekEnd.toISOString(),
    });

    currentWeekStart.setDate(currentWeekStart.getDate() + 7);
  }

  return weeks;
};

const fetchAllWorkingTimes = async () => {
  workingTimesChartData.value = [];
  
  const { firstDay, lastDay } = getMonthDays(currentYear, currentMonth);

  if (selectedPeriod.value === 'week') {
    const firstDayOfWeek = new Date();
    firstDayOfWeek.setDate(firstDayOfWeek.getDate() - (firstDayOfWeek.getDay() === 0 ? 6 : firstDayOfWeek.getDay() - 1));
    const lastDayOfWeek = new Date();
    lastDayOfWeek.setDate(firstDayOfWeek.getDate() + 6);

    const workingTimesMonth = await fetchWorkingTimesForMonth(firstDayOfWeek.toISOString(), lastDayOfWeek.toISOString());
    for (let i = 0; i < 7; i++) {
      const day = new Date(firstDayOfWeek);
      day.setDate(day.getDate() + i);
      const dayString = day.toISOString().split('T')[0];

      const dailyDuration = workingTimesMonth.reduce((total, work) => {
        const workDate = new Date(work.start).toISOString().split('T')[0];
        if (workDate === dayString) {
          return total + calculateDuration(new Date(work.start), new Date(work.end));
        }
        return total;
      }, 0);

      workingTimesChartData.value.push({
        name: dayString,
        minutes: dailyDuration,
        time: Math.floor(dailyDuration / 60) + " hours " + dailyDuration % 60 + " minutes",
      });
    }
  } else if (selectedPeriod.value === 'month') {
    const weeks = getWeeksInCurrentMonth(firstDay, lastDay);
    for (const week of weeks) {
      const workingTimesWeek = await fetchWorkingTimesForMonth(week.start, week.end);
      let total = 0;
      workingTimesWeek.forEach((work) => {
        const duration = calculateDuration(new Date(work.start), new Date(work.end));
        total += duration;
      });
      workingTimesChartData.value.push({
        name: `Week from ${new Date(week.start).toLocaleDateString()} to ${new Date(week.end).toLocaleDateString()}`,
        minutes: Math.floor(total),
        time: Math.floor(total / 60) + " hours " + total % 60 + " minutes",
      });
    }
  } else if (selectedPeriod.value === 'year') {
    for (const monthData of monthlyData) {
      const workingTimesMonth = await fetchWorkingTimesForMonth(monthData.firstDay, monthData.lastDay);
      let total = 0;
      workingTimesMonth.forEach((work) => {
        const duration = calculateDuration(new Date(work.start), new Date(work.end));
        total += duration;
      });
      workingTimesChartData.value.push({
        name: monthData.name,
        minutes: Math.floor(total),
        time: Math.floor(total / 60) + " hours " + total % 60 + " minutes",
      });
    }
  }

  data.value = workingTimesChartData.value;
};

watch(selectedPeriod, () => {
  fetchAllWorkingTimes();
});

onMounted(() => {
  fetchAllWorkingTimes();
});
</script>

<template>
  <div>
    <div class="flex space-x-4 mb-4">
      <button @click="selectedPeriod = 'week'" :class="{ 'bg-blue-500 text-white': selectedPeriod === 'week' }" class="px-4 rounded-md py-2">Semaine</button>
      <button @click="selectedPeriod = 'month'" :class="{ 'bg-blue-500 text-white': selectedPeriod === 'month' }" class="px-4 rounded-md py-2">Mois</button>
      <button @click="selectedPeriod = 'year'" :class="{ 'bg-blue-500 text-white': selectedPeriod === 'year' }" class="px-4 rounded-md py-2">Année</button>
    </div>
    <BarChart :data="data" :categories="['minutes']" :index="'name'" :rounded-corners="4" />
  </div>
</template>
