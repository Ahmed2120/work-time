// ==========================================================================
// WORK TIME ADMIN DASHBOARD — ADVANCED FILTERING ENGINE
// ==========================================================================

const FilterEngine = {
  // ─── Determine Engagement Status ────────────────────────────────────────
  getEngagementStatus(device) {
    const now = new Date();
    const emp = Number(device.employeeCount || 0);
    const proj = Number(device.projectsCount || 0);
    let diffDays = 999;
    if (device.lastSeen) {
      diffDays = (now - new Date(device.lastSeen)) / (1000 * 60 * 60 * 24);
    }

    if (emp > 0 || proj > 0) {
      if (diffDays <= 7) {
        return {
          key: 'real-employer-active',
          label: '👑 صاحب عمل نشط فعلي',
          subLabel: `${emp} عمال • ${proj} مشاريع`,
          badgeClass: 'badge-success',
          isRealEmployer: true,
          isActive: true
        };
      } else {
        return {
          key: 'real-employer-dormant',
          label: '⚠️ صاحب عمل خامل مؤخراً',
          subLabel: `${emp} عمال (لم يفتح منذ ${Math.round(diffDays)} يوم)`,
          badgeClass: 'badge-warning',
          isRealEmployer: true,
          isActive: false
        };
      }
    } else {
      if (diffDays <= 2) {
        return {
          key: 'trial-tester',
          label: '⚡ تجربة جديدة (0 عمال)',
          subLabel: 'فتح التطبيق حديثاً',
          badgeClass: 'badge-purple',
          isRealEmployer: false,
          isActive: true
        };
      } else {
        return {
          key: 'dormant-visitor',
          label: '💤 حساب خامل (0 عمال)',
          subLabel: `مهجور منذ ${Math.round(diffDays)} يوم`,
          badgeClass: 'badge-neutral',
          isRealEmployer: false,
          isActive: false
        };
      }
    }
  },

  // ─── Filter Devices ─────────────────────────────────────────────────────
  filterDevices(devices, filters) {
    const now = new Date();

    return devices
      .filter((device) => {
        // 1. Search Query
        if (filters.search) {
          const q = filters.search.toLowerCase().trim();
          const matchUuid = (device.uuid || '').toLowerCase().includes(q);
          const matchModel = (device.deviceModel || '').toLowerCase().includes(q);
          const matchOs = (device.osVersion || '').toLowerCase().includes(q);
          if (!matchUuid && !matchModel && !matchOs) return false;
        }

        // 2. Engagement Filter (Real active employers vs dormant)
        if (filters.engagement && filters.engagement !== 'all') {
          const eng = this.getEngagementStatus(device);
          if (filters.engagement === 'real-employers' && !eng.isRealEmployer) return false;
          if (filters.engagement === 'active-only' && !eng.isActive) return false;
          if (filters.engagement === 'dormant' && eng.isActive) return false;
        }

        // 3. Subscription Status
        if (filters.subscription !== 'all') {
          if (filters.subscription === 'subscribed' && !device.isSubscribed) return false;
          if (filters.subscription === 'trial' && (!device.isTrial || device.isSubscribed)) return false;
          if (filters.subscription === 'expired' && (device.isSubscribed || device.isTrial)) return false;
        }

        // 4. Activity Timeframe
        if (filters.activity !== 'all' && device.lastSeen) {
          const lastSeenDate = new Date(device.lastSeen);
          const diffHours = (now - lastSeenDate) / (1000 * 60 * 60);

          if (filters.activity === 'today' && diffHours > 24) return false;
          if (filters.activity === '7d' && diffHours > 24 * 7) return false;
          if (filters.activity === '30d' && diffHours > 24 * 30) return false;
          if (filters.activity === 'inactive' && diffHours <= 24 * 30) return false;
        }

        // 5. OS Version
        if (filters.osVersion !== 'all') {
          const os = (device.osVersion || '').toLowerCase();
          if (!os.includes(filters.osVersion.toLowerCase())) return false;
        }

        // 6. Work Scale
        if (filters.workScale !== 'all') {
          const emp = Number(device.employeeCount || 0);
          const proj = Number(device.projectsCount || 0);
          if (filters.workScale === 'has-workers' && emp === 0) return false;
          if (filters.workScale === 'has-projects' && proj === 0) return false;
          if (filters.workScale === 'zero' && (emp > 0 || proj > 0)) return false;
        }

        return true;
      })
      .sort((a, b) => {
        // Dynamic Sorting
        const field = filters.sortField || 'lastSeen';
        const isDesc = filters.sortOrder === 'desc';

        let valA = a[field];
        let valB = b[field];

        if (field === 'lastSeen' || field === 'firstSeen') {
          valA = valA ? new Date(valA).getTime() : 0;
          valB = valB ? new Date(valB).getTime() : 0;
        } else {
          valA = Number(valA) || 0;
          valB = Number(valB) || 0;
        }

        return isDesc ? valB - valA : valA - valB;
      });
  },

  // ─── Filter Feedbacks ───────────────────────────────────────────────────
  filterFeedbacks(feedbacks, filters) {
    const now = new Date();

    return feedbacks
      .filter((fb) => {
        // 1. Search Query
        if (filters.search) {
          const q = filters.search.toLowerCase().trim();
          const matchMsg = (fb.message || '').toLowerCase().includes(q);
          const matchContact = (fb.contactInfo || '').toLowerCase().includes(q);
          const matchModel = (fb.deviceModel || '').toLowerCase().includes(q);
          if (!matchMsg && !matchContact && !matchModel) return false;
        }

        // 2. Type
        if (filters.type !== 'all') {
          const type = fb.type || '';
          if (filters.type === 'feature' && !type.includes('اقتراح')) return false;
          if (filters.type === 'bug' && !type.includes('مشكلة') && !type.includes('عطل')) return false;
          if (filters.type === 'general' && !type.includes('عام')) return false;
        }

        // 3. Contact Available
        if (filters.hasContact !== 'all') {
          const has = Boolean((fb.contactInfo || '').trim());
          if (filters.hasContact === 'with-contact' && !has) return false;
          if (filters.hasContact === 'anonymous' && has) return false;
        }

        // 4. Timeframe
        if (filters.timeframe !== 'all' && fb.createdAt) {
          const created = new Date(fb.createdAt);
          const diffHours = (now - created) / (1000 * 60 * 60);

          if (filters.timeframe === 'today' && diffHours > 24) return false;
          if (filters.timeframe === 'week' && diffHours > 24 * 7) return false;
          if (filters.timeframe === 'month' && diffHours > 24 * 30) return false;
        }

        return true;
      })
      .sort((a, b) => {
        const timeA = a.createdAt ? new Date(a.createdAt).getTime() : 0;
        const timeB = b.createdAt ? new Date(b.createdAt).getTime() : 0;
        return timeB - timeA; // newest first
      });
  },

  // ─── Filter Users ───────────────────────────────────────────────────────
  filterUsers(users, filters) {
    return users.filter((u) => {
      if (!filters.search) return true;
      const q = filters.search.toLowerCase().trim();
      const matchEmail = (u.email || u.id || '').toLowerCase().includes(q);
      const matchToken = (u.deviceToken || '').toLowerCase().includes(q);
      return matchEmail || matchToken;
    });
  }
};

window.FilterEngine = FilterEngine;
