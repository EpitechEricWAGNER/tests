<script setup lang="ts">
import { ref } from "vue";
import { Check, ChevronsUpDown } from "lucide-vue-next";

import { cn } from "@/lib/utils";
import { Button } from "@/components/ui/button";
import {
  Command,
  CommandEmpty,
  CommandGroup,
  CommandInput,
  CommandItem,
  CommandList,
} from "@/components/ui/command";
import {
  Popover,
  PopoverContent,
  PopoverTrigger,
} from "@/components/ui/popover";

const users = [
  { value: "user1", label: "User 1" },
  { value: "user2", label: "User 2" },
  { value: "user3", label: "User 3" },
  { value: "user4", label: "User 4" },
  { value: "user5", label: "User 5" },
];



const open = ref(false);
const value = ref("");
</script>

<template>
  <nav
    :class="cn('flex items-center space-x-4 lg:space-x-6', $attrs.class ?? '')"
  >
    <Popover v-model:open="open">
      <PopoverTrigger as-child>
        <Button
          variant="outline"
          role="combobox"
          :aria-expanded="open"
          class="w-[200px] justify-between"
        >
          {{
            value
              ? users.find((user) => user.value === value)?.label
              : "Select user..."
          }}
          <ChevronsUpDown class="ml-2 h-4 w-4 shrink-0 opacity-50" />
        </Button>
      </PopoverTrigger>
      <PopoverContent class="w-[200px] p-0">
        <Command>
          <CommandInput class="h-9" placeholder="Search user..." /> 
          <CommandEmpty>No user found.</CommandEmpty>
          <CommandList>
            <CommandGroup>
              <CommandItem
                v-for="user in users"
                :key="user.value"
                :value="user.value"
                @select="
                  (ev) => {
                    if (typeof ev.detail.value === 'string') {
                      value = ev.detail.value;
                    }
                    open = false;
                  }
                "
              >
                {{ user.label }}
                <Check
                  :class="
                    cn(
                      'ml-auto h-4 w-4',
                      value === user.value ? 'opacity-100' : 'opacity-0'
                    )
                  "
                />
              </CommandItem>
            </CommandGroup>
          </CommandList>
        </Command>
      </PopoverContent>
    </Popover>
  </nav>
</template>
