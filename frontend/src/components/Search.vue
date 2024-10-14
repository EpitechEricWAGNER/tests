<script setup lang="ts">
import { ref } from 'vue';
import { Input } from '@/components/ui/input';
import { useStore } from 'vuex';
import userService from '@/services/userService';
import { User } from '@/store';

const searchQuery = ref<string>('');
const store = useStore();

const searchUser = async () => {
  try {
    const userData = {
      username: '',
      email: ''
    };
    if (searchQuery.value.includes('@')) {
      userData.email = searchQuery.value;
    } else {
      userData.username = searchQuery.value;
    }
    const user: User = await userService.getUser(userData);
    console.log('Utilisateur trouvé :', user);
    store.commit('setUser', user);
  } catch (error) {
    console.error('Erreur lors de la recherche utilisateur:', error);
  }
};
</script>

<template>
  <div>
    <Input type="search" v-model="searchQuery" placeholder="Search by email or username..."
      class="md:w-[100px] lg:w-[300px]" @keyup.enter="searchUser" />
  </div>
</template>
