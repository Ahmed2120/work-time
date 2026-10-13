// ==========================================================================
// WORK TIME ADMIN DASHBOARD — CORE APPLICATION CONTROLLER
// ==========================================================================

document.addEventListener('DOMContentLoaded', () => {
  // 1. Initialize Theme
  const savedTheme = localStorage.getItem('wt_theme') || 'dark';
  window.appState.setTheme(savedTheme);

  // 2. Initialize Firebase
  window.firebaseService.init();

  // 3. Setup Navigation & Tabs
  setupTabNavigation();

  // 4. Setup Theme Toggle
  setupThemeToggle();

  // 5. Setup Filter Event Listeners
  setupDeviceFilters();
  setupFeedbackFilters();
  setupUserFilters();

  // 6. Setup Export & Actions
  setupExportActions();

  // 7. Setup Auth & Demo Mode
  setupAuthHandlers();

  // 8. Subscribe to AppState changes
  window.appState.subscribe(renderDashboard);

  // 9. Initial Load: Check auth or load Demo Data
  checkInitialAuthAndLoad();
});

// ─── TAB NAVIGATION ──────────────────────────────────────────────────────────

function setupTabNavigation() {
  const tabButtons = document.querySelectorAll('.tab-btn');
  tabButtons.forEach((btn) => {
    btn.addEventListener('click', () => {
      const tabTarget = btn.getAttribute('data-tab');
      if (!tabTarget) return;

      tabButtons.forEach(b => b.classList.remove('active'));
      btn.classList.add('active');

      document.querySelectorAll('.tab-content').forEach(section => {
        section.classList.remove('active');
      });

      const targetSection = document.getElementById(`tab-${tabTarget}`);
      if (targetSection) targetSection.classList.add('active');

      window.appState.setTab(tabTarget);
    });
  });
}

// ─── THEME TOGGLE ────────────────────────────────────────────────────────────

function setupThemeToggle() {
  const toggleBtn = document.getElementById('theme-toggle-btn');
  if (toggleBtn) {
    toggleBtn.addEventListener('click', () => {
      window.appState.toggleTheme();
      // Re-render charts with new theme colors
      window.dashboardCharts.updateAll(window.appState.devices);
    });
  }
}

// ─── AUTH & INITIAL LOAD ─────────────────────────────────────────────────────

function setupAuthHandlers() {
  const modal = document.getElementById('auth-modal');
  const loginForm = document.getElementById('login-form');
  const demoBtn = document.getElementById('demo-mode-btn');
  const openLoginBtn = document.getElementById('open-login-btn');
  const logoutBtn = document.getElementById('logout-btn');

  if (openLoginBtn) {
    openLoginBtn.addEventListener('click', () => {
      modal.classList.add('show');
    });
  }

  const closeModalBtn = document.getElementById('close-modal-btn');
  if (closeModalBtn) {
    closeModalBtn.addEventListener('click', () => {
      modal.classList.remove('show');
    });
  }

  if (demoBtn) {
    demoBtn.addEventListener('click', () => {
      enableDemoMode();
      modal.classList.remove('show');
      showToast('تم تفعيل وضع العرض التجريبي (Demo Mode) بنجاح');
    });
  }

  if (loginForm) {
    loginForm.addEventListener('submit', async (e) => {
      e.preventDefault();
      const email = document.getElementById('login-email').value;
      const pass = document.getElementById('login-password').value;
      const submitBtn = loginForm.querySelector('button[type="submit"]');

      submitBtn.disabled = true;
      submitBtn.textContent = 'جارٍ التحقق...';

      try {
        await window.firebaseService.signIn(email, pass);
        modal.classList.remove('show');
        showToast('تم تسجيل الدخول بنجاح! جارٍ تحميل البيانات الحية');
        loadLiveFirebaseData();
      } catch (err) {
        alert('فشل تسجيل الدخول: ' + (err.message || 'تأكد من البريد وكلمة المرور في Firebase'));
      } finally {
        submitBtn.disabled = false;
        submitBtn.textContent = 'تسجيل الدخول';
      }
    });
  }

  if (logoutBtn) {
    logoutBtn.addEventListener('click', async () => {
      await window.firebaseService.signOut();
      window.appState.isAuthenticated = false;
      enableDemoMode();
      showToast('تم تسجيل الخروج — تم التحويل للوضع التجريبي');
    });
  }

  // Refresh live data button
  const refreshBtn = document.getElementById('refresh-btn');
  if (refreshBtn) {
    refreshBtn.addEventListener('click', async () => {
      refreshBtn.classList.add('spinning');
      if (window.appState.isDemoMode) {
        enableDemoMode();
      } else {
        await loadLiveFirebaseData();
      }
      setTimeout(() => refreshBtn.classList.remove('spinning'), 600);
      showToast('تم تحديث البيانات بنجاح 🔄');
    });
  }
}

async function checkInitialAuthAndLoad() {
  try {
    // 1. Immediately attempt to fetch real data from Firebase
    await loadLiveFirebaseData();
  } catch (err) {
    console.warn("Could not load real data initially, falling back to demo mode:", err);
    enableDemoMode();
  }

  // 2. Setup auth listener if Firebase Auth is active
  if (window.firebaseService.auth) {
    window.firebaseService.auth.onAuthStateChanged((user) => {
      if (user) {
        window.appState.isAuthenticated = true;
        const loginBtn = document.getElementById('open-login-btn');
        if (loginBtn) {
          loginBtn.textContent = '👤 ' + (user.email ? user.email.split('@')[0] : 'Admin');
        }
      }
    });
  }
}

function enableDemoMode() {
  window.appState.setDemoMode(true);
  window.appState.setDevices(window.mockData.devices);
  window.appState.setFeedbacks(window.mockData.feedbacks);
  window.appState.setUsers(window.mockData.users);
}

async function loadLiveFirebaseData() {
  const modePill = document.getElementById('mode-indicator');
  if (modePill) {
    modePill.innerHTML = '<span class="badge-dot" style="background:#3b82f6"></span> جارٍ جلب البيانات الحية...';
    modePill.className = 'live-indicator';
  }

  try {
    const [devices, feedbacks, users] = await Promise.all([
      window.firebaseService.fetchDevices(),
      window.firebaseService.fetchFeedbacks(),
      window.firebaseService.fetchUsers()
    ]);

    const devCount = Object.keys(devices || {}).length;

    window.appState.setDemoMode(false);
    window.appState.setDevices(devices);
    window.appState.setFeedbacks(feedbacks);
    window.appState.setUsers(users);

    updateSyncTimestamp();
    showToast(`تم تحميل البيانات الحية بنجاح (${devCount} جهاز) 🟢`);

    // Setup real-time live listeners
    if (window.firebaseService.database) {
      window.firebaseService.listenDevices((liveDevs) => {
        window.appState.setDevices(liveDevs);
        updateSyncTimestamp();
      });
      window.firebaseService.listenFeedbacks((liveFbs) => {
        window.appState.setFeedbacks(liveFbs);
      });
    }
  } catch (err) {
    console.warn("Could not fetch live Firebase data, switching to demo mode:", err);
    enableDemoMode();
    showToast('تعذر جلب البيانات الحية — تم التحويل للوضع التجريبي');
    throw err;
  }
}

// ─── FILTER EVENT LISTENERS ──────────────────────────────────────────────────

function setupDeviceFilters() {
  const searchInput = document.getElementById('dev-search');
  const engSelect = document.getElementById('dev-engagement-filter');
  const subSelect = document.getElementById('dev-sub-filter');
  const activitySelect = document.getElementById('dev-activity-filter');
  const osSelect = document.getElementById('dev-os-filter');
  const scaleSelect = document.getElementById('dev-scale-filter');
  const sortSelect = document.getElementById('dev-sort-filter');
  const resetBtn = document.getElementById('dev-reset-btn');

  let debounceTimer;
  if (searchInput) {
    searchInput.addEventListener('input', (e) => {
      clearTimeout(debounceTimer);
      debounceTimer = setTimeout(() => {
        window.appState.updateDeviceFilter('search', e.target.value);
      }, 200);
    });
  }

  if (engSelect) {
    engSelect.addEventListener('change', (e) => {
      window.appState.updateDeviceFilter('engagement', e.target.value);
    });
  }

  if (subSelect) {
    subSelect.addEventListener('change', (e) => {
      window.appState.updateDeviceFilter('subscription', e.target.value);
    });
  }

  if (activitySelect) {
    activitySelect.addEventListener('change', (e) => {
      window.appState.updateDeviceFilter('activity', e.target.value);
    });
  }

  if (osSelect) {
    osSelect.addEventListener('change', (e) => {
      window.appState.updateDeviceFilter('osVersion', e.target.value);
    });
  }

  if (scaleSelect) {
    scaleSelect.addEventListener('change', (e) => {
      window.appState.updateDeviceFilter('workScale', e.target.value);
    });
  }

  if (sortSelect) {
    sortSelect.addEventListener('change', (e) => {
      const [field, order] = e.target.value.split('-');
      window.appState.updateDeviceFilter('sortField', field);
      window.appState.updateDeviceFilter('sortOrder', order || 'desc');
    });
  }

  if (resetBtn) {
    resetBtn.addEventListener('click', () => {
      if (searchInput) searchInput.value = '';
      if (engSelect) engSelect.value = 'all';
      if (subSelect) subSelect.value = 'all';
      if (activitySelect) activitySelect.value = 'all';
      if (osSelect) osSelect.value = 'all';
      if (scaleSelect) scaleSelect.value = 'all';
      if (sortSelect) sortSelect.value = 'lastSeen-desc';
      window.appState.resetDeviceFilters();
    });
  }

  // Quick Chips
  document.querySelectorAll('.device-chip').forEach(chip => {
    chip.addEventListener('click', () => {
      document.querySelectorAll('.device-chip').forEach(c => c.classList.remove('active'));
      document.querySelectorAll('.eng-chip').forEach(c => c.classList.remove('active'));
      chip.classList.add('active');
      const val = chip.getAttribute('data-filter');
      window.appState.updateDeviceFilter('subscription', val);
      if (subSelect) subSelect.value = val;
    });
  });

  document.querySelectorAll('.eng-chip').forEach(chip => {
    chip.addEventListener('click', () => {
      document.querySelectorAll('.device-chip').forEach(c => c.classList.remove('active'));
      document.querySelectorAll('.eng-chip').forEach(c => c.classList.remove('active'));
      chip.classList.add('active');
      const val = chip.getAttribute('data-filter');
      window.appState.updateDeviceFilter('engagement', val);
      if (engSelect) engSelect.value = val;
    });
  });
}

function setupFeedbackFilters() {
  const searchInput = document.getElementById('fb-search');
  const typeSelect = document.getElementById('fb-type-filter');
  const contactSelect = document.getElementById('fb-contact-filter');
  const timeSelect = document.getElementById('fb-time-filter');
  const resetBtn = document.getElementById('fb-reset-btn');

  let debounceTimer;
  if (searchInput) {
    searchInput.addEventListener('input', (e) => {
      clearTimeout(debounceTimer);
      debounceTimer = setTimeout(() => {
        window.appState.updateFeedbackFilter('search', e.target.value);
      }, 200);
    });
  }

  if (typeSelect) {
    typeSelect.addEventListener('change', (e) => {
      window.appState.updateFeedbackFilter('type', e.target.value);
    });
  }

  if (contactSelect) {
    contactSelect.addEventListener('change', (e) => {
      window.appState.updateFeedbackFilter('hasContact', e.target.value);
    });
  }

  if (timeSelect) {
    timeSelect.addEventListener('change', (e) => {
      window.appState.updateFeedbackFilter('timeframe', e.target.value);
    });
  }

  if (resetBtn) {
    resetBtn.addEventListener('click', () => {
      if (searchInput) searchInput.value = '';
      if (typeSelect) typeSelect.value = 'all';
      if (contactSelect) contactSelect.value = 'all';
      if (timeSelect) timeSelect.value = 'all';
      window.appState.resetFeedbackFilters();
    });
  }
}

function setupUserFilters() {
  const searchInput = document.getElementById('usr-search');
  if (searchInput) {
    searchInput.addEventListener('input', (e) => {
      window.appState.userFilters.search = e.target.value;
      renderUsersTab();
    });
  }
}

// ─── RENDERING MAIN UI ───────────────────────────────────────────────────────

function renderDashboard(state) {
  // Update status badge (Live vs Demo)
  const modePill = document.getElementById('mode-indicator');
  if (modePill) {
    if (state.isDemoMode) {
      modePill.innerHTML = '<span class="badge-dot" style="background:#f59e0b"></span> وضع تجريبي (Demo)';
      modePill.className = 'live-indicator badge-warning';
    } else {
      modePill.innerHTML = '<span class="pulse-dot"></span> متصل بقاعدة Firebase';
      modePill.className = 'live-indicator badge-success';
    }
  }

  // Update Badge Counts
  const devBadge = document.getElementById('tab-count-devices');
  if (devBadge) devBadge.textContent = state.devices.length;

  const fbBadge = document.getElementById('tab-count-feedbacks');
  if (fbBadge) fbBadge.textContent = state.feedbacks.length;

  const usrBadge = document.getElementById('tab-count-users');
  if (usrBadge) usrBadge.textContent = state.users.length;

  // Render KPIs
  renderOverviewKPIs(state);

  // Render Charts
  window.dashboardCharts.updateAll(state.devices);

  // Render Specific Tabs
  renderDevicesTab();
  renderFeedbacksTab();
  renderUsersTab();
}

function renderOverviewKPIs(state) {
  const now = new Date();
  let activeToday = 0;
  let activeWeek = 0;
  let subscribedCount = 0;
  let totalWorkers = 0;
  let totalProjects = 0;
  let realEmployersCount = 0;

  state.devices.forEach((d) => {
    if (d.isSubscribed) subscribedCount++;
    totalWorkers += Number(d.employeeCount || 0);
    totalProjects += Number(d.projectsCount || 0);

    const eng = window.FilterEngine.getEngagementStatus(d);
    if (eng.isRealEmployer) realEmployersCount++;

    if (d.lastSeen) {
      const diffHours = (now - new Date(d.lastSeen)) / (1000 * 60 * 60);
      if (diffHours <= 24) activeToday++;
      if (diffHours <= 24 * 7) activeWeek++;
    }
  });

  const total = state.devices.length || 1;
  const subRate = Math.round((subscribedCount / total) * 100);

  setKpiText('kpi-total-devices', state.devices.length);
  setKpiText('kpi-real-employers', realEmployersCount);
  setKpiText('kpi-active-today', activeToday);
  setKpiText('kpi-active-week', activeWeek);
  setKpiText('kpi-sub-rate', `${subRate}%`);
  setKpiText('kpi-total-workers', totalWorkers);
  setKpiText('kpi-total-projects', totalProjects);
}

function setKpiText(id, val) {
  const el = document.getElementById(id);
  if (el) el.textContent = val;
}

// ─── RENDER DEVICES TAB ──────────────────────────────────────────────────────

function renderDevicesTab() {
  const tbody = document.getElementById('devices-tbody');
  const countEl = document.getElementById('filtered-devices-count');
  if (!tbody) return;

  const filtered = window.FilterEngine.filterDevices(
    window.appState.devices,
    window.appState.deviceFilters
  );

  if (countEl) countEl.textContent = `${filtered.length} من إجمالي ${window.appState.devices.length}`;

  if (filtered.length === 0) {
    tbody.innerHTML = `
      <tr>
        <td colspan="7" style="text-align: center; padding: 2.5rem; color: var(--text-muted);">
          🔍 لا توجد أجهزة تطابق معايير الفلترة المحددة
        </td>
      </tr>`;
    return;
  }

  tbody.innerHTML = filtered.map((dev) => {
    const subBadge = dev.isSubscribed
      ? '<span class="badge badge-success"><span class="badge-dot"></span> مشترك مدفوع</span>'
      : dev.isTrial
        ? '<span class="badge badge-warning"><span class="badge-dot"></span> فترة تجريبية</span>'
        : '<span class="badge badge-neutral"><span class="badge-dot"></span> منتهي التجربة</span>';

    const eng = window.FilterEngine.getEngagementStatus(dev);
    const shortUuid = dev.uuid ? `${dev.uuid.substring(0, 8)}...` : 'N/A';
    const lastSeenRelative = formatRelativeTime(dev.lastSeen);

    return `
      <tr>
        <td>
          <button class="btn btn-secondary btn-sm" onclick="copyToClipboard('${dev.uuid}')" title="نسخ المعرف الكامل">
            <code>${shortUuid}</code> 📋
          </button>
        </td>
        <td>
          <strong>${escapeHtml(dev.deviceModel || 'Unknown')}</strong>
        </td>
        <td>
          <span class="badge ${eng.badgeClass}">${eng.label}</span>
          <div style="font-size:0.7rem; color:var(--text-muted); margin-top:2px;">${eng.subLabel}</div>
        </td>
        <td>
          <span class="badge badge-purple">${escapeHtml(dev.osVersion || 'Android')}</span>
        </td>
        <td>${subBadge}</td>
        <td>
          <strong style="color:${dev.employeeCount > 0 ? 'var(--color-success)' : 'var(--text-muted)'};">${dev.employeeCount || 0}</strong> عامل
        </td>
        <td>
          <strong style="color:${dev.projectsCount > 0 ? 'var(--color-purple)' : 'var(--text-muted)'};">${dev.projectsCount || 0}</strong> مشروع
        </td>
        <td>
          <span title="${dev.lastSeen || ''}">${lastSeenRelative}</span>
        </td>
        <td>
          <button class="btn btn-secondary btn-sm" onclick="handleDeleteDevice('${dev.uuid}')" style="color:var(--color-danger); border-color:rgba(239,68,68,0.25);" title="حذف الجهاز من قاعدة البيانات">
            🗑️ حذف
          </button>
        </td>
      </tr>
    `;
  }).join('');
}

// ─── RENDER FEEDBACKS TAB ────────────────────────────────────────────────────

function renderFeedbacksTab() {
  const container = document.getElementById('feedbacks-grid');
  const countEl = document.getElementById('filtered-feedbacks-count');
  if (!container) return;

  const filtered = window.FilterEngine.filterFeedbacks(
    window.appState.feedbacks,
    window.appState.feedbackFilters
  );

  if (countEl) countEl.textContent = `${filtered.length} رسالة`;

  if (filtered.length === 0) {
    container.innerHTML = `
      <div style="grid-column: 1/-1; text-align: center; padding: 3rem; color: var(--text-muted); background: var(--bg-card); border-radius: var(--radius-lg); border: 1px solid var(--border-color);">
        📭 لا توجد رسائل أو مقترحات تطابق الفلتر الحالي
      </div>`;
    return;
  }

  container.innerHTML = filtered.map((fb) => {
    let typeClass = 'badge-neutral';
    if ((fb.type || '').includes('اقتراح')) typeClass = 'badge-warning';
    if ((fb.type || '').includes('مشكلة') || (fb.type || '').includes('عطل')) typeClass = 'badge-danger';
    if ((fb.type || '').includes('عام')) typeClass = 'badge-purple';

    const contact = (fb.contactInfo || '').trim();
    const isPhone = /^[0-9+\s-]{8,15}$/.test(contact);

    let contactAction = '';
    if (contact) {
      if (isPhone) {
        const cleanPhone = contact.replace(/[^0-9]/g, '');
        contactAction = `
          <a href="https://wa.me/2${cleanPhone}" target="_blank" class="btn btn-sm btn-primary" style="background:#25D366;border-color:#25D366;">
            💬 واتساب
          </a>
          <button class="btn btn-sm btn-secondary" onclick="copyToClipboard('${contact}')">
            📞 نسخ الرقم
          </button>`;
      } else {
        contactAction = `
          <a href="mailto:${contact}" class="btn btn-sm btn-primary">
            ✉️ إرسال بريد
          </a>
          <button class="btn btn-sm btn-secondary" onclick="copyToClipboard('${contact}')">
            📋 نسخ
          </button>`;
      }
    }

    return `
      <div class="feedback-card">
        <div class="feedback-card-header">
          <span class="badge ${typeClass} feedback-type-badge">${fb.type || 'رأي'}</span>
          <span style="font-size:0.75rem; color:var(--text-muted);">${formatRelativeTime(fb.createdAt)}</span>
        </div>

        <div class="feedback-body">
          "${escapeHtml(fb.message || '')}"
        </div>

        <div class="feedback-meta">
          <div>📱 <strong>الجهاز:</strong> ${fb.deviceModel || 'Unknown Device'}</div>
          <div>📞 <strong>التواصل:</strong> ${contact ? `<span style="color:var(--text-primary); font-weight:600;">${contact}</span>` : '<span style="color:var(--text-muted);">غير متوفر</span>'}</div>
        </div>

        ${contactAction ? `<div class="feedback-actions">${contactAction}</div>` : ''}
      </div>
    `;
  }).join('');
}

// ─── RENDER USERS TAB ────────────────────────────────────────────────────────

function renderUsersTab() {
  const tbody = document.getElementById('users-tbody');
  const countEl = document.getElementById('filtered-users-count');
  if (!tbody) return;

  const filtered = window.FilterEngine.filterUsers(
    window.appState.users,
    window.appState.userFilters
  );

  if (countEl) countEl.textContent = `${filtered.length} حساب`;

  if (filtered.length === 0) {
    tbody.innerHTML = `
      <tr>
        <td colspan="5" style="text-align: center; padding: 2.5rem; color: var(--text-muted);">
          👥 لا توجد حسابات مسجلة مطابقة للبحث
        </td>
      </tr>`;
    return;
  }

  tbody.innerHTML = filtered.map((u) => {
    const rawKey = u.id || '';
    const email = u.email || rawKey.replace(/,/g, '.');
    return `
      <tr>
        <td><strong>${escapeHtml(email)}</strong></td>
        <td><code>${escapeHtml(u.deviceToken || 'غير مرتبط')}</code></td>
        <td><span class="badge badge-success"><span class="badge-dot"></span> ${u.status || 'Active'}</span></td>
        <td><span class="badge badge-purple">${u.plan || 'Standard'}</span></td>
        <td>
          <button class="btn btn-secondary btn-sm" onclick="handleDeleteUser('${rawKey}')" style="color:var(--color-danger); border-color:rgba(239,68,68,0.25);" title="حذف الحساب من قاعدة البيانات">
            🗑️ حذف الحساب
          </button>
        </td>
      </tr>
    `;
  }).join('');
}

// ─── DELETE HANDLERS ─────────────────────────────────────────────────────────

async function handleDeleteUser(userKey) {
  const display = userKey.replace(/,/g, '.');
  if (!confirm(`هل أنت متأكد من حذف الحساب "${display}" نهائياً من قاعدة بيانات Firebase؟`)) return;
  try {
    await window.firebaseService.deleteUser(userKey);
    showToast(`تم حذف الحساب "${display}" بنجاح 🗑️`);
    const newUsers = window.appState.users.filter(u => (u.id || '') !== userKey);
    window.appState.setUsers(newUsers.reduce((acc, cur) => { acc[cur.id] = cur; return acc; }, {}));
  } catch (err) {
    alert('فشل حذف الحساب: ' + err.message);
  }
}
window.handleDeleteUser = handleDeleteUser;

async function handleDeleteDevice(uuid) {
  if (!confirm(`هل أنت متأكد من حذف هذا الجهاز (${uuid.substring(0, 8)}...) نهائياً من قاعدة البيانات؟`)) return;
  try {
    await window.firebaseService.deleteDevice(uuid);
    showToast(`تم حذف الجهاز بنجاح 🗑️`);
    const newDevs = window.appState.devices.filter(d => (d.uuid || d.id) !== uuid);
    window.appState.setDevices(newDevs.reduce((acc, cur) => { acc[cur.uuid || cur.id] = cur; return acc; }, {}));
  } catch (err) {
    alert('فشل حذف الجهاز: ' + err.message);
  }
}
window.handleDeleteDevice = handleDeleteDevice;

// ─── EXPORT ACTIONS (CSV) ────────────────────────────────────────────────────

function setupExportActions() {
  const exportDevBtn = document.getElementById('export-devices-csv');
  if (exportDevBtn) {
    exportDevBtn.addEventListener('click', () => {
      const filtered = window.FilterEngine.filterDevices(
        window.appState.devices,
        window.appState.deviceFilters
      );
      exportToCsv('devices_report.csv', [
        ['UUID', 'Device Model', 'OS Version', 'Is Subscribed', 'Is Trial', 'Employees', 'Projects', 'First Seen', 'Last Seen'],
        ...filtered.map(d => [
          d.uuid,
          d.deviceModel,
          d.osVersion,
          d.isSubscribed ? 'Yes' : 'No',
          d.isTrial ? 'Yes' : 'No',
          d.employeeCount,
          d.projectsCount,
          d.firstSeen,
          d.lastSeen
        ])
      ]);
      showToast('تم تصدير تقرير الأجهزة إلى CSV 📁');
    });
  }

  const exportFbBtn = document.getElementById('export-feedbacks-csv');
  if (exportFbBtn) {
    exportFbBtn.addEventListener('click', () => {
      const filtered = window.FilterEngine.filterFeedbacks(
        window.appState.feedbacks,
        window.appState.feedbackFilters
      );
      exportToCsv('feedbacks_report.csv', [
        ['Type', 'Message', 'Contact', 'Device Model', 'Created At'],
        ...filtered.map(f => [
          f.type,
          f.message,
          f.contactInfo,
          f.deviceModel,
          f.createdAt
        ])
      ]);
      showToast('تم تصدير تقرير المقترحات إلى CSV 📁');
    });
  }
}

function exportToCsv(filename, rows) {
  const processRow = row => row.map(val => `"${(val || '').toString().replace(/"/g, '""')}"`).join(',');
  const csvContent = "\uFEFF" + rows.map(processRow).join('\r\n');
  const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
  const link = document.createElement('a');
  link.href = URL.createObjectURL(blob);
  link.setAttribute('download', filename);
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
}

// ─── HELPERS ─────────────────────────────────────────────────────────────────

function formatRelativeTime(dateStr) {
  if (!dateStr) return 'غير محدد';
  const date = new Date(dateStr);
  const now = new Date();
  const diffSec = Math.floor((now - date) / 1000);

  if (diffSec < 60) return 'الآن';
  if (diffSec < 3600) return `منذ ${Math.floor(diffSec / 60)} دقيقة`;
  if (diffSec < 86400) return `منذ ${Math.floor(diffSec / 3600)} ساعة`;
  if (diffSec < 86400 * 7) return `منذ ${Math.floor(diffSec / 86400)} يوم`;
  return date.toLocaleDateString('ar-EG', { month: 'short', day: 'numeric' });
}

function updateSyncTimestamp() {
  const timeEl = document.getElementById('last-sync-time');
  if (timeEl) {
    const now = new Date();
    timeEl.textContent = now.toLocaleTimeString('ar-EG', { hour: '2-digit', minute: '2-digit', second: '2-digit' });
  }
}

function copyToClipboard(text) {
  navigator.clipboard.writeText(text).then(() => {
    showToast(`تم النسخ: ${text.substring(0, 20)}... 📋`);
  });
}
window.copyToClipboard = copyToClipboard;

function showToast(msg) {
  const container = document.getElementById('toast-container');
  if (!container) return;
  const toast = document.createElement('div');
  toast.className = 'toast';
  toast.innerHTML = `<span>ℹ️</span> <span>${msg}</span>`;
  container.appendChild(toast);
  setTimeout(() => {
    toast.style.opacity = '0';
    setTimeout(() => toast.remove(), 250);
  }, 3000);
}

function escapeHtml(str) {
  return (str || '').replace(/[&<>"']/g, m => ({
    '&': '&amp;',
    '<': '&lt;',
    '>': '&gt;',
    '"': '&quot;',
    "'": '&#39;'
  })[m]);
}
