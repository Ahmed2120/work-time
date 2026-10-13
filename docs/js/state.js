// ==========================================================================
// WORK TIME ADMIN DASHBOARD — CENTRAL STATE MANAGEMENT
// ==========================================================================

class AppState {
  constructor() {
    this.isDemoMode = false;
    this.isAuthenticated = false;
    this.activeTab = 'overview';
    this.theme = localStorage.getItem('wt_theme') || 'dark';

    // Raw datasets
    this.devices = [];
    this.feedbacks = [];
    this.users = [];

    // Filter criteria for Devices
    this.deviceFilters = {
      search: '',
      engagement: 'all',       // all, real-employers, active-only, dormant
      subscription: 'all',     // all, subscribed, trial, expired
      activity: 'all',         // all, today, 7d, 30d, inactive
      osVersion: 'all',        // all, android14, android13, etc.
      workScale: 'all',        // all, has-workers, has-projects, zero
      sortField: 'lastSeen',   // lastSeen, firstSeen, employeeCount, projectsCount
      sortOrder: 'desc'
    };

    // Filter criteria for Feedbacks
    this.feedbackFilters = {
      search: '',
      type: 'all',             // all, feature, bug, general
      hasContact: 'all',       // all, with-contact, anonymous
      timeframe: 'all'         // all, today, week, month
    };

    // Filter criteria for Users
    this.userFilters = {
      search: ''
    };

    this.listeners = [];
  }

  setTheme(theme) {
    this.theme = theme;
    localStorage.setItem('wt_theme', theme);
    document.documentElement.setAttribute('data-theme', theme);
    this.notify();
  }

  toggleTheme() {
    this.setTheme(this.theme === 'dark' ? 'light' : 'dark');
  }

  setTab(tabName) {
    this.activeTab = tabName;
    this.notify();
  }

  setDemoMode(val) {
    this.isDemoMode = val;
    this.notify();
  }

  setDevices(devicesObj) {
    this.devices = Object.entries(devicesObj || {}).map(([key, val]) => ({
      id: key,
      ...val
    }));
    this.notify();
  }

  setFeedbacks(feedbacksObj) {
    this.feedbacks = Object.entries(feedbacksObj || {}).map(([key, val]) => ({
      id: key,
      ...val
    }));
    this.notify();
  }

  setUsers(usersObj) {
    this.users = Object.entries(usersObj || {}).map(([key, val]) => ({
      id: key,
      ...val
    }));
    this.notify();
  }

  updateDeviceFilter(key, value) {
    this.deviceFilters[key] = value;
    this.notify();
  }

  resetDeviceFilters() {
    this.deviceFilters = {
      search: '',
      engagement: 'all',
      subscription: 'all',
      activity: 'all',
      osVersion: 'all',
      workScale: 'all',
      sortField: 'lastSeen',
      sortOrder: 'desc'
    };
    this.notify();
  }

  updateFeedbackFilter(key, value) {
    this.feedbackFilters[key] = value;
    this.notify();
  }

  resetFeedbackFilters() {
    this.feedbackFilters = {
      search: '',
      type: 'all',
      hasContact: 'all',
      timeframe: 'all'
    };
    this.notify();
  }

  subscribe(callback) {
    this.listeners.push(callback);
    return () => {
      this.listeners = this.listeners.filter(cb => cb !== callback);
    };
  }

  notify() {
    this.listeners.forEach(cb => cb(this));
  }
}

window.appState = new AppState();
