<script setup lang="ts">
import { Calendar as CalendarIcon } from "lucide-vue-next";
import type { DateRange } from "radix-vue";
import {
    CalendarDate,
    DateFormatter,
    getLocalTimeZone,
} from "@internationalized/date";

import { type Ref, ref, watch } from "vue";
import { cn } from "@/lib/utils";
import { Button } from "@/components/ui/button";
import { RangeCalendar } from "@/components/ui/range-calendar";
import {
    Popover,
    PopoverContent,
    PopoverTrigger,
} from "@/components/ui/popover";
import { useStore } from 'vuex'

const df = new DateFormatter('fr-FR', {
  dateStyle: 'medium',
})
const store = useStore()

const today = new Date()
store.commit('setDateRange', {
  startDateRange: today.getFullYear() + "-" + (today.getMonth()+1) + "-" + today.getDate(),
  endDateRange: today.getFullYear() + "-" + (today.getMonth()+1) + "-" + today.getDate()
})
const calendarDate = new CalendarDate(today.getFullYear(), today.getMonth()+1, today.getDate())

const value = ref({
  start: calendarDate,
  end: calendarDate,
}) as Ref<DateRange>

const emit = defineEmits(['date-change'])

watch(value, (newValue) => {
  // si on clique une fois alors on ne fais rien
  if (!newValue.start &&!newValue.end) return
  const formatValue = (val) => val.toString().padStart(2, '0');

  emit('date-change', {
    startDateRange: newValue.start.year + "-" + formatValue(newValue.start.month) + "-" + formatValue(newValue.start.day),
    endDateRange: newValue.end.year + "-" + formatValue(newValue.end.month) + "-" + formatValue(newValue.end.day),
  });
})

</script>

<template>
    <div :class="cn('grid gap-2', $attrs.class ?? '')">
        <Popover>
            <PopoverTrigger as-child>
                <Button
                    id="date"
                    :variant="'outline'"
                    :class="
                        cn(
                            'w-[300px] justify-start text-left font-normal',
                            !value && 'text-muted-foreground'
                        )
                    "
                >
                    <CalendarIcon class="mr-2 h-4 w-4" />

                    <template v-if="value.start">
                        <template v-if="value.end">
                            {{
                                df.format(
                                    value.start.toDate(getLocalTimeZone())
                                )
                            }}
                            -
                            {{
                                df.format(value.end.toDate(getLocalTimeZone()))
                            }}
                        </template>

            <template v-else>
              {{ df.format(value.start.toDate(getLocalTimeZone())) }}
            </template>
          </template>
          <template v-else>
            Pick a date
          </template>
        </Button>
      </PopoverTrigger>
      <PopoverContent class="w-auto p-0" align="end">
        <RangeCalendar v-model="value" weekday-format="short" :number-of-months="2" initial-focus
          :placeholder="value.start" @update:start-value="(startDate) => value.start = startDate " />
      </PopoverContent>
    </Popover>
  </div>
</template>
