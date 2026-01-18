<script setup>
import { useConfigStore } from '@/stores/config'
import { delay, RowValue, animate, useMotionValue, useTransform } from 'motion-v'
import { onUnmounted, watch } from 'vue'
import LatestMatch from './LatestMatch.vue'
import TodayStats from './TodayStats.vue'
import WinrateBadge from './WinrateBadge.vue'
import { eloChangeFormatter } from '@/lib/eloChangeForametter'

const {
  nickname,
  elo,
  eloRank,
  rank,
  rankIcon,
  badge,
  accent,
  eloChange,
  wins,
  loses,
  avg,
  winrate,
  opponentNickname,
  opponentElo,
  opponentResult,
} = defineProps({
  nickname: String,
  elo: Number,
  eloRank: Number,
  rank: String,
  rankIcon: String,
  badge: Number,
  accent: String,
  eloChange: Number,
  wins: Number,
  loses: Number,
  avg: String,
  winrate: Number,
  opponentNickname: String,
  opponentElo: Number,
  opponentResult: Number,
})

const changeCounter = useMotionValue(Math.abs(eloChange))
const changeRounded = useTransform(() => Math.round(changeCounter.get()))

watch(
  () => eloChange,
  (newEloChange) => {
    animate(changeCounter, Math.abs(newEloChange), {
      duration: 0.5,
    })
  },
)

const configStore = useConfigStore()

const toggleLatest = () => {
  configStore.isLatest = !configStore.isLatest
  delay(() => {
    configStore.isLatest = !configStore.isLatest
  }, configStore.rate)
}

const intervalID = setInterval(toggleLatest, (configStore.rate * 1000) / 2 + 20)

switch (configStore.state) {
  case 1:
    clearInterval(intervalID)
    setInterval(() => (configStore.isLatest = !configStore.isLatest), configStore.rate * 1000 + 20)
    break
  case 2:
    clearInterval(intervalID)
    break
  case 3:
    clearInterval(intervalID)
    break
  case 4:
    clearInterval(intervalID)
    configStore.isLatest = !configStore.isLatest
    break
}

const eloCounter = useMotionValue(elo)
const eloRounded = useTransform(() => Math.round(eloCounter.get()))

watch(
  () => elo,
  (newElo) => {
    animate(eloCounter, newElo, {
      duration: 0.5,
    })
  },
)

const leaderboardCounter = useMotionValue(eloRank)
const leaderboardRounded = useTransform(() => Math.round(leaderboardCounter.get()))

watch(
  () => eloRank,
  (newRank) => {
    animate(leaderboardCounter, newRank, {
      duration: 0.5,
    })
  },
)

onUnmounted(() => {
  clearInterval(intervalID)
})
</script>

<template>
  <div class="expanded">
    <div class="expanded-info">
      <div class="expanded-info-stats">
        <!-- Elo + leaderboard values -->
        <div class="expanded-info-stats-block">
          <span class="expanded-info-stats__text">W/L {{ wins || 0 }}/{{ loses || 0 }} • rank</span>
          <div class="expanded-info-stats-leader expanded-info-stats__text">
            <span class="expanded-info-stats__hashtag">#</span>
            <RowValue class="expanded-info-stats__text" :value="leaderboardRounded" />
          </div>
        </div>

        <div class="expanded-info-stats-rank">
          <img
            :src="`/icons/${rankIcon || 'coal'}.png`"
            alt="rank icon"
            class="expanded-info-stats-rank__icon"
          />
          <span class="expanded-info-stats-rank__text"><RowValue :value="eloRounded" /> elo </span>

          <span
            class="miminized-info__text"
            :class="{
              'miminized-info__text--positive': eloChange > 0,
              'miminized-info__text--negative': eloChange < 0,
            }"
            >({{ eloChangeFormatter(eloChange) }}<RowValue :value="changeRounded" />)</span
          >
        </div>
      </div>

      <img
        v-if="badge === 1"
        src="/src/assets/icons/ranked.png"
        alt="ranked icon"
        class="expanded-info__icon"
      />
      <WinrateBadge v-if="badge === 2" :percentage="winrate" :accent="accent" />
      <img
        v-if="badge === 3"
        :src="`https://mineskin.eu/helm/${nickname}/7.png`"
        alt="player head"
        class="expanded-info__head"
      />
    </div>
  </div>
</template>

<style scoped>
.expanded {
  display: flex;
  width: 100%;
  flex-direction: column;
  align-items: center;
  gap: 1rem;
}
.expanded-info {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  align-self: stretch;
}
.expanded-info-stats {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: flex-start;
  gap: 0.25rem;
  height: 100%;
}
.expanded-info-stats-block {
  display: flex;
  align-items: flex-start;
  gap: 0.3rem;
  margin-top: 1px;
}
.expanded-info-stats__text {
  color: oklch(82.7% 0.119 306.383);
  font-size: 1rem;
  font-weight: 550;
  line-height: 1rem;
  letter-spacing: -0.01488rem;
}
.expanded-info-stats-leader {
  display: flex;
  align-items: flex-end;
}
.expanded-info-stats-rank {
  display: flex;
  align-items: flex-start;
  gap: 0.25rem;
}
.expanded-info-stats-rank__text {
  color: #fff;
  font-size: 1.5rem;
  font-weight: 650;
  line-height: calc(1.5rem - 2px);
  letter-spacing: -0.01488rem;
}
.expanded-info-stats-rank__icon {
  width: 1.5rem;
  height: 1.5rem;
}
.expanded-info__icon {
  width: 2rem;
  height: 2rem;
}
.expanded-info__head {
  width: 3rem;
  height: 3rem;
  border-radius: 0.25rem;
  image-rendering: crisp-edges;
}
.miminized-info__text {
  color: #a4a4a9;
  text-align: center;
  font-size: 1.4rem;
  margin-left: 2px;
  font-weight: 650;
  line-height: calc(1.5rem - 2px);
  letter-spacing: -0.01488rem;
}
.miminized-info__text--positive {
  color: oklch(79.2% 0.209 151.711);
}
.miminized-info__text--negative {
  color: oklch(63.7% 0.237 25.331);
}
</style>
