// ==========================================================================
// WORK TIME ADMIN DASHBOARD — CHART.JS VISUALIZATIONS
// ==========================================================================

class DashboardCharts {
  constructor() {
    this.instances = {};
  }

  getThemeColors() {
    const isDark = document.documentElement.getAttribute('data-theme') !== 'light';
    return {
      textColor: isDark ? '#94a3b8' : '#475569',
      gridColor: isDark ? 'rgba(255, 255, 255, 0.05)' : 'rgba(0, 0, 0, 0.06)',
      accent: '#3b82f6',
      emerald: '#10b981',
      amber: '#f59e0b',
      purple: '#8b5cf6',
      cyan: '#06b6d4',
      danger: '#ef4444'
    };
  }

  // 1. Subscription Breakdown (Donut)
  renderSubscriptionChart(canvasId, devices) {
    const ctx = document.getElementById(canvasId);
    if (!ctx) return;

    if (this.instances.subscription) {
      this.instances.subscription.destroy();
    }

    let subscribed = 0;
    let trial = 0;
    let expired = 0;

    devices.forEach((d) => {
      if (d.isSubscribed) subscribed++;
      else if (d.isTrial) trial++;
      else expired++;
    });

    const colors = this.getThemeColors();

    this.instances.subscription = new Chart(ctx, {
      type: 'doughnut',
      data: {
        labels: ['مشترك (Subscribed)', 'فترة تجريبية (Trial)', 'منتهي التجربة (Free)'],
        datasets: [{
          data: [subscribed, trial, expired],
          backgroundColor: [colors.emerald, colors.amber, colors.purple],
          borderWidth: 0,
          hoverOffset: 6
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            position: 'bottom',
            labels: {
              color: colors.textColor,
              font: { family: 'Cairo, Outfit', size: 12 },
              padding: 16
            }
          }
        },
        cutout: '68%'
      }
    });
  }

  // 2. Device Brands Distribution (Horizontal Bar)
  renderBrandsChart(canvasId, devices) {
    const ctx = document.getElementById(canvasId);
    if (!ctx) return;

    if (this.instances.brands) {
      this.instances.brands.destroy();
    }

    const brandCounts = {};
    devices.forEach((d) => {
      const model = (d.deviceModel || 'Unknown').trim();
      const brand = model.split(' ')[0] || 'Unknown';
      brandCounts[brand] = (brandCounts[brand] || 0) + 1;
    });

    const sortedBrands = Object.entries(brandCounts)
      .sort((a, b) => b[1] - a[1])
      .slice(0, 5);

    const colors = this.getThemeColors();

    this.instances.brands = new Chart(ctx, {
      type: 'bar',
      data: {
        labels: sortedBrands.map(b => b[0]),
        datasets: [{
          label: 'عدد الأجهزة',
          data: sortedBrands.map(b => b[1]),
          backgroundColor: colors.accent,
          borderRadius: 8
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: { display: false }
        },
        scales: {
          x: {
            grid: { color: colors.gridColor },
            ticks: { color: colors.textColor }
          },
          y: {
            beginAtZero: true,
            grid: { color: colors.gridColor },
            ticks: { color: colors.textColor, stepSize: 1 }
          }
        }
      }
    });
  }

  // 3. Workforce Scale Distribution (Bar)
  renderWorkforceChart(canvasId, devices) {
    const ctx = document.getElementById(canvasId);
    if (!ctx) return;

    if (this.instances.workforce) {
      this.instances.workforce.destroy();
    }

    let zero = 0;
    let small = 0;   // 1-5
    let medium = 0;  // 6-20
    let large = 0;   // 21+

    devices.forEach((d) => {
      const c = Number(d.employeeCount || 0);
      if (c === 0) zero++;
      else if (c <= 5) small++;
      else if (c <= 20) medium++;
      else large++;
    });

    const colors = this.getThemeColors();

    this.instances.workforce = new Chart(ctx, {
      type: 'bar',
      data: {
        labels: ['بدون عمال (0)', 'صغير (1-5)', 'متوسط (6-20)', 'كبير (+20)'],
        datasets: [{
          label: 'أصحاب العمل',
          data: [zero, small, medium, large],
          backgroundColor: [colors.textColor, colors.cyan, colors.purple, colors.emerald],
          borderRadius: 8
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: { display: false }
        },
        scales: {
          x: {
            grid: { color: colors.gridColor },
            ticks: { color: colors.textColor, font: { family: 'Cairo' } }
          },
          y: {
            beginAtZero: true,
            grid: { color: colors.gridColor },
            ticks: { color: colors.textColor, stepSize: 1 }
          }
        }
      }
    });
  }

  // 4. Activity Over Time (Line / Area)
  renderActivityChart(canvasId, devices) {
    const ctx = document.getElementById(canvasId);
    if (!ctx) return;

    if (this.instances.activity) {
      this.instances.activity.destroy();
    }

    // Group lastSeen by last 7 days
    const dayCounts = {};
    for (let i = 6; i >= 0; i--) {
      const d = new Date();
      d.setDate(d.getDate() - i);
      const label = d.toLocaleDateString('ar-EG', { weekday: 'short', month: 'numeric', day: 'numeric' });
      dayCounts[label] = 0;
    }

    devices.forEach((dev) => {
      if (dev.lastSeen) {
        const devDate = new Date(dev.lastSeen);
        const label = devDate.toLocaleDateString('ar-EG', { weekday: 'short', month: 'numeric', day: 'numeric' });
        if (dayCounts[label] !== undefined) {
          dayCounts[label]++;
        }
      }
    });

    const colors = this.getThemeColors();

    this.instances.activity = new Chart(ctx, {
      type: 'line',
      data: {
        labels: Object.keys(dayCounts),
        datasets: [{
          label: 'الأجهزة النشطة',
          data: Object.values(dayCounts),
          borderColor: colors.accent,
          backgroundColor: 'rgba(59, 130, 246, 0.15)',
          fill: true,
          tension: 0.35,
          pointRadius: 4,
          pointBackgroundColor: colors.accent
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: { display: false }
        },
        scales: {
          x: {
            grid: { color: colors.gridColor },
            ticks: { color: colors.textColor, font: { family: 'Cairo' } }
          },
          y: {
            beginAtZero: true,
            grid: { color: colors.gridColor },
            ticks: { color: colors.textColor, stepSize: 1 }
          }
        }
      }
    });
  }

  updateAll(devices) {
    this.renderSubscriptionChart('chart-subscription', devices);
    this.renderBrandsChart('chart-brands', devices);
    this.renderWorkforceChart('chart-workforce', devices);
    this.renderActivityChart('chart-activity', devices);
  }
}

window.dashboardCharts = new DashboardCharts();
