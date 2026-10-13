// ==========================================================================
// WORK TIME ADMIN DASHBOARD — DEMO & SEED DATA
// ==========================================================================

window.mockData = {
  devices: {
    "dev-001": {
      uuid: "550e8400-e29b-41d4-a716-446655440001",
      deviceModel: "Samsung Galaxy S22 Ultra",
      osVersion: "Android 14",
      employeeCount: 24,
      projectsCount: 3,
      isSubscribed: true,
      isTrial: false,
      firstSeen: "2026-08-10T14:22:00.000Z",
      lastSeen: new Date(Date.now() - 1000 * 60 * 25).toISOString() // 25 mins ago
    },
    "dev-002": {
      uuid: "550e8400-e29b-41d4-a716-446655440002",
      deviceModel: "Xiaomi Redmi Note 12 Pro",
      osVersion: "Android 13",
      employeeCount: 8,
      projectsCount: 1,
      isSubscribed: false,
      isTrial: true,
      firstSeen: "2026-09-02T09:15:00.000Z",
      lastSeen: new Date(Date.now() - 1000 * 60 * 120).toISOString() // 2 hours ago
    },
    "dev-003": {
      uuid: "550e8400-e29b-41d4-a716-446655440003",
      deviceModel: "Realme 11 Pro+",
      osVersion: "Android 13",
      employeeCount: 42,
      projectsCount: 5,
      isSubscribed: true,
      isTrial: false,
      firstSeen: "2026-07-15T11:40:00.000Z",
      lastSeen: new Date(Date.now() - 1000 * 60 * 60 * 5).toISOString() // 5 hours ago
    },
    "dev-004": {
      uuid: "550e8400-e29b-41d4-a716-446655440004",
      deviceModel: "Samsung Galaxy A54",
      osVersion: "Android 14",
      employeeCount: 15,
      projectsCount: 2,
      isSubscribed: false,
      isTrial: true,
      firstSeen: "2026-09-20T18:05:00.000Z",
      lastSeen: new Date(Date.now() - 1000 * 60 * 60 * 26).toISOString() // yesterday
    },
    "dev-005": {
      uuid: "550e8400-e29b-41d4-a716-446655440005",
      deviceModel: "Oppo Reno 10",
      osVersion: "Android 13",
      employeeCount: 3,
      projectsCount: 0,
      isSubscribed: false,
      isTrial: false,
      firstSeen: "2026-06-11T16:50:00.000Z",
      lastSeen: new Date(Date.now() - 1000 * 60 * 60 * 24 * 14).toISOString() // 14 days ago
    },
    "dev-006": {
      uuid: "550e8400-e29b-41d4-a716-446655440006",
      deviceModel: "Infinix Note 30",
      osVersion: "Android 12",
      employeeCount: 19,
      projectsCount: 2,
      isSubscribed: true,
      isTrial: false,
      firstSeen: "2026-08-01T12:00:00.000Z",
      lastSeen: new Date(Date.now() - 1000 * 60 * 60 * 2).toISOString()
    },
    "dev-007": {
      uuid: "550e8400-e29b-41d4-a716-446655440007",
      deviceModel: "Samsung Galaxy S23 FE",
      osVersion: "Android 14",
      employeeCount: 31,
      projectsCount: 4,
      isSubscribed: true,
      isTrial: false,
      firstSeen: "2026-08-25T10:10:00.000Z",
      lastSeen: new Date(Date.now() - 1000 * 60 * 45).toISOString()
    },
    "dev-008": {
      uuid: "550e8400-e29b-41d4-a716-446655440008",
      deviceModel: "Xiaomi Poco X5 Pro",
      osVersion: "Android 13",
      employeeCount: 6,
      projectsCount: 1,
      isSubscribed: false,
      isTrial: true,
      firstSeen: "2026-09-28T08:30:00.000Z",
      lastSeen: new Date(Date.now() - 1000 * 60 * 60 * 18).toISOString()
    }
  },

  feedbacks: {
    "fb-001": {
      uuid: "550e8400-e29b-41d4-a716-446655440001",
      type: "اقتراح ميزة 💡",
      message: "تطبيق ممتاز جداً، هل يمكن إضافة إمكانية تصدير تقرير الرواتب كملف PDF مخصص مع لوجو المؤسسة؟",
      contactInfo: "01098765432",
      deviceModel: "Samsung Galaxy S22 Ultra",
      createdAt: new Date(Date.now() - 1000 * 60 * 60 * 4).toISOString()
    },
    "fb-002": {
      uuid: "550e8400-e29b-41d4-a716-446655440003",
      type: "رأي عام 💬",
      message: "أفضل تطبيق لإدارة عمال اليوميات والمقاولات في مصر، وفّر علينا دفاتر كتير. بالتوفيق!",
      contactInfo: "eng.mohamed@gmail.com",
      deviceModel: "Realme 11 Pro+",
      createdAt: new Date(Date.now() - 1000 * 60 * 60 * 28).toISOString()
    },
    "fb-003": {
      uuid: "550e8400-e29b-41d4-a716-446655440002",
      type: "مشكلة أو عطل ⚠️",
      message: "عند إضافة سلفة جديدة في نفس اليوم لعامل، يظهر تنبيه أحياناً قبل التأكيد.",
      contactInfo: "01123456789",
      deviceModel: "Xiaomi Redmi Note 12 Pro",
      createdAt: new Date(Date.now() - 1000 * 60 * 60 * 48).toISOString()
    },
    "fb-004": {
      uuid: "550e8400-e29b-41d4-a716-446655440007",
      type: "اقتراح ميزة 💡",
      message: "نرجو إضافة خاصية نسخ احتياطي سحابي تلقائي على Google Drive بجانب النسخ المحلي.",
      contactInfo: "01055554433",
      deviceModel: "Samsung Galaxy S23 FE",
      createdAt: new Date(Date.now() - 1000 * 60 * 60 * 72).toISOString()
    }
  },

  users: {
    "ahmed,worktime@gmail,com": {
      deviceToken: "samsung:TP1A.220624.014",
      email: "ahmed.worktime@gmail.com",
      status: "active",
      plan: "Premium Lifetime",
      registeredAt: "2026-07-01T10:00:00.000Z"
    },
    "contractor,cairo@gmail,com": {
      deviceToken: "realme:SP1A.210812.016",
      email: "contractor.cairo@gmail.com",
      status: "active",
      plan: "Annual 2026",
      registeredAt: "2026-08-15T12:30:00.000Z"
    }
  }
};
