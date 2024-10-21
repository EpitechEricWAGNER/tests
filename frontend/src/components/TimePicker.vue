<template>
  <div class="flex flex-col items-center">
    <div class="flex items-center my-2.5">
      <select
        v-model="localHours"
        @change="updateHours"
        id="hours"
        class="p-1.5 border border-solid border-gray-300 rounded-md bg-gray-50 text-sm"
      >
        <option
          v-for="hour in hoursRange"
          :key="hour"
          :value="hour"
        >
          {{ formatTime(hour) }}
        </option>
      </select>

      <span class="mx-1.5">:</span>

      <select
        v-model="localMinutes"
        @change="updateMinutes"
        id="minutes"
        class="p-1.5 border border-solid border-gray-300 rounded-md bg-gray-50 text-sm"
      >
        <option
          v-for="minute in minutesRange"
          :key="minute"
          :value="minute"
        >
          {{ formatTime(minute) }}
        </option>
      </select>
    </div>
    <span id="selected-time" class="hidden" :data-label="localLabel">{{ formattedTime }}</span>
  </div>
</template>


<script lang="ts">
import { defineComponent, ref, watch, computed } from 'vue';

export default defineComponent({
  props: {
    hours: {
      type: Number,
      required: true
    },
    minutes: {
      type: Number,
      required: true
    },
    label: {
      type: String,
      default: '',
      required: false,
    },
  },
  emits: ['update:hours', 'update:minutes'],
  setup(props, { emit }) {
    const localHours = ref(props.hours);
    const localMinutes = ref(props.minutes);
    const localLabel = ref(props.label || '');

    const hoursRange = Array.from({ length: 24 }, (_, i) => i);
    const minutesRange = Array.from({ length: 60 }, (_, i) => i);

    const formattedTime = computed(() => {
      return `${formatTime(localHours.value)}:${formatTime(localMinutes.value)}`;
    });

    const formatTime = (value: number) => (value < 10 ? '0' + value : value);

    const updateHours = () => {
      emit('update:hours', localHours.value);
    };

    const updateMinutes = () => {
      emit('update:minutes', localMinutes.value);
    };

    watch(() => props.hours, (newVal) => {
      localHours.value = newVal;
    });

    watch(() => props.minutes, (newVal) => {
      localMinutes.value = newVal;
    });

    watch(() => props.label, (newVal) => {
      localLabel.value = newVal;
    });

    return {
      localLabel,
      localHours,
      localMinutes,
      hoursRange,
      minutesRange,
      formattedTime,
      formatTime,
      updateHours,
      updateMinutes,
    };
  },
});
</script>