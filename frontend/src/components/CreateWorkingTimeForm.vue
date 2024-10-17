<script setup lang="ts">
import { ref, computed, h } from 'vue';
import { useForm } from 'vee-validate';
import { toTypedSchema } from '@vee-validate/zod';
import * as z from 'zod';
import { Input } from '@/components/ui/input';
import { FormControl, FormDescription, FormField, FormItem, FormLabel, FormMessage } from '@/components/ui/form';
import { Separator } from '@/components/ui/separator';
import { Select, SelectContent, SelectGroup, SelectItem, SelectLabel, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Button } from '@/components/ui/button';
import userService from '@/services/userService';
import TimePicker from './TimePicker.vue';
import { CalendarDate, DateFormatter, getLocalTimeZone, parseDate, today } from '@internationalized/date'
import { toDate } from 'radix-vue/date'
import { Calendar as CalendarIcon } from 'lucide-vue-next'
import { Calendar } from '@/components/ui/calendar'
import { Popover, PopoverContent, PopoverTrigger } from '@/components/ui/popover'
import { cn } from '@/utils'
import { workingtimeService } from '@/services/workingtimeService';

const users = ref([]);
const getUsers = async () => {
  const response = await userService.getAllUsers();
  users.value = response;
};
getUsers();

const schema = z.object({
  userId: z.string().nonempty(),
  hoursStart: z.number().min(0, 'Invalid hours').max(23, 'Invalid hours'),
  minutesStart: z.number().min(0, 'Invalid minutes').max(59, 'Invalid minutes'),
  hoursEnd: z.number().min(0, 'Invalid hours').max(23, 'Invalid hours'),
  minutesEnd: z.number().min(0, 'Invalid minutes').max(59, 'Invalid minutes'),
  dateStart: z
    .string()
    .refine(v => v, { message: 'A date of birth is required.' }),
  dateEnd: z
    .string()
    .refine(v => v, { message: 'A date of birth is required.' }),
});

const placeholder = ref()

const { handleSubmit, setFieldValue, errors, values } = useForm({
  validationSchema: toTypedSchema(schema),
  initialValues: {
    userId: '',
    hoursStart: 0,
    minutesStart: 0,
    hoursEnd: 0,
    minutesEnd: 0,
    dateStart: '',
    dateEnd: '',
  },
});
const valueStart = computed({
  get: () => values.dateStart ? parseDate(values.dateStart) : undefined,
  set: val => val,
})

const valueEnd = computed({
  get: () => values.dateEnd ? parseDate(values.dateEnd) : undefined,
  set: val => val,
})

const successMessage = ref<string>("");
const errorMessage = ref<string>("");
const submitForm = handleSubmit(async values => {
  const selectedTimes = document.querySelectorAll('#selected-time');
  selectedTimes.forEach(time => {
    const dataLabel = time.getAttribute('data-label');
    if (dataLabel === "StartTime") {
      values.hoursStart = parseInt(time.textContent.split(':')[0]);
      values.minutesStart = parseInt(time.textContent.split(':')[1]);
    } else if (dataLabel === "EndTime") {
      values.hoursEnd = parseInt(time.textContent.split(':')[0]);
      values.minutesEnd = parseInt(time.textContent.split(':')[1]);
    }
  });
  const padZero = (num: number) => num.toString().padStart(2, '0');
  
  const formattedDateStart = values.dateStart;
  const formattedDateEnd = values.dateEnd;
  
  const formattedTimeStart = `${padZero(values.hoursStart)}:${padZero(values.minutesStart)}:00`;
  const formattedTimeEnd = `${padZero(values.hoursEnd)}:${padZero(values.minutesEnd)}:00`;

  let startDateTime = `${formattedDateStart}T${formattedTimeStart}`;
  let endDateTime = `${formattedDateEnd}T${formattedTimeEnd}`;

  if (new Date(startDateTime).getTime() > new Date(endDateTime).getTime()) {
    errorMessage.value = "Start date cannot be later than the end date";
    successMessage.value = "";
    return;
  } else if (new Date(startDateTime).getTime() == new Date(endDateTime).getTime()) {
    errorMessage.value = "Start and end date cannot be the same";
    successMessage.value = "";
    return;
  }

  const datas = {
    user: values.userId,
    start: startDateTime,
    end: endDateTime,
  };
  try {
    await workingtimeService.createWorkingTime(datas);
    errorMessage.value = "";
    successMessage.value = "Working time created successfully !"; 
  }
  catch {
    errorMessage.value = "Failed to create working time";
    successMessage.value = "";
    return;
  }
});
const df = new DateFormatter('en-US', {
  dateStyle: 'long',
})

</script>

<template>
  <form @submit="submitForm" class="space-y-8">
    <FormField name="userId" v-slot="{ componentField, errors }">
      <FormItem>
        <FormLabel>Select an Employee</FormLabel>
        <FormControl>
          <Select v-bind="componentField">
            <SelectTrigger>
              <SelectValue placeholder="Select an employee" />
            </SelectTrigger>
            <SelectContent>
              <SelectGroup>
                <SelectLabel>Employees</SelectLabel>
                <template v-for="user in users" :key="user.id">
                  <SelectItem :value="String(user.id)">{{ user.username }}</SelectItem>
                </template>
              </SelectGroup>
            </SelectContent>
          </Select>
        </FormControl>
        <FormMessage>{{ errors.userId }}</FormMessage>
      </FormItem>
    </FormField>

    <Separator />

    <div class="flex space-x-4 items-center">
      <FormField name="dob">
        <FormItem class="flex flex-col">
          <FormLabel>Starting Date</FormLabel>
          <Popover>
            <PopoverTrigger as-child>
              <FormControl>
                <Button
                  variant="outline"
                  :class="cn(
                    'w-[240px] ps-3 text-start font-normal',
                    !valueStart && 'text-muted-foreground'
                  )"
                >
                  <span>{{ valueStart ? df.format(toDate(valueStart)) : 'Pick a date' }}</span>
                  <CalendarIcon class="ms-auto h-4 w-4 opacity-50" />
                </Button>
                <input hidden />
              </FormControl>
            </PopoverTrigger>
            <PopoverContent class="w-auto p-0">
              <Calendar
                v-model:placeholder="placeholder"
                v-model="valueStart"
                calendar-label="Date of birth"
                initial-focus
                :min-value="new CalendarDate(1900, 1, 1)"
                @update:model-value="(v) => {
                  if (v) {
                    setFieldValue('dateStart', v.toString());
                  } else {
                    setFieldValue('dateStart', undefined);
                  }
                }"
              />
            </PopoverContent>
          </Popover>
          <FormDescription>The starting date is required.</FormDescription>
          <FormMessage />
        </FormItem>
      </FormField>

      <TimePicker
        v-model:hours="values.hoursStart"
        v-model:minutes="values.minutesStart"
        label="StartTime"
      />
    </div>

    <div class="flex space-x-4 items-center">
      <FormField name="dob">
        <FormItem class="flex flex-col">
          <FormLabel>Ending Date</FormLabel>
          <Popover>
            <PopoverTrigger as-child>
              <FormControl>
                <Button
                  variant="outline"
                  :class="cn(
                    'w-[240px] ps-3 text-start font-normal',
                    !valueEnd && 'text-muted-foreground'
                  )"
                >
                  <span>{{ valueEnd ? df.format(toDate(valueEnd)) : 'Pick a date' }}</span>
                  <CalendarIcon class="ms-auto h-4 w-4 opacity-50" />
                </Button>
                <input hidden />
              </FormControl>
            </PopoverTrigger>
            <PopoverContent class="w-auto p-0">
              <Calendar
                v-model:placeholder="placeholder"
                v-model="valueEnd"
                calendar-label="Date of birth"
                initial-focus
                :min-value="new CalendarDate(1900, 1, 1)"
                @update:model-value="(v) => {
                  if (v) {
                    setFieldValue('dateEnd', v.toString());
                  } else {
                    setFieldValue('dateEnd', undefined);
                  }
                }"
              />
            </PopoverContent>
          </Popover>
          <FormDescription>The ending date is required.</FormDescription>
          <FormMessage />
        </FormItem>
      </FormField>

      <TimePicker
        v-model:hours="values.hoursEnd"
        v-model:minutes="values.minutesEnd"
        label="EndTime"
      />
    </div>

    <p v-if="errors.hoursStart || errors.minutesStart" class="text-red-500">
      {{ errors.hoursStart || errors.minutesStart }}
    </p>
    <p v-if="errors.hoursEnd || errors.minutesEnd" class="text-red-500">
      {{ errors.hoursEnd || errors.minutesEnd }}
    </p>
    <div class="flex gap-2 justify-start">
      <Button type="submit">Submit</Button>
    </div>
  </form>
  <div v-if="successMessage" class="mt-4 text-green-600">
    {{ successMessage }}
  </div>
  <div v-if="errorMessage" class="mt-4 text-red-600">
    {{ errorMessage }}
  </div>
</template>


