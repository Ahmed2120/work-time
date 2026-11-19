// ==========================================================================
// WORK TIME ADMIN DASHBOARD — FIREBASE INTEGRATION & CLIENT
// ==========================================================================

const firebaseConfig = {
  apiKey: "AIzaSyCAJQW1Z8hkIa2LRPAkdTC2Jmkw9V98cXg",
  authDomain: "worktime-33fa5.firebaseapp.com",
  databaseURL: "https://worktime-33fa5-default-rtdb.firebaseio.com",
  projectId: "worktime-33fa5",
  storageBucket: "worktime-33fa5.firebasestorage.app",
  messagingSenderId: "577113528629",
  appId: "1:577113528629:web:cd35f030514e740898147c",
  measurementId: "G-LYKMFETRLN"
};

class FirebaseService {
  constructor() {
    this.app = null;
    this.auth = null;
    this.database = null;
    this.isInitialized = false;
    this.currentUser = null;
  }

  init() {
    try {
      if (typeof firebase !== 'undefined' && !firebase.apps.length) {
        this.app = firebase.initializeApp(firebaseConfig);
        this.auth = firebase.auth();
        this.database = firebase.database();
        this.isInitialized = true;
        console.log("Firebase initialized successfully for Work Time");
      }
    } catch (e) {
      console.warn("Firebase initialization notice:", e);
    }
  }

  async signIn(email, password) {
    if (!this.auth) throw new Error("Firebase Auth not initialized");
    const userCredential = await this.auth.signInWithEmailAndPassword(email, password);
    this.currentUser = userCredential.user;
    return this.currentUser;
  }

  async signOut() {
    if (this.auth) {
      await this.auth.signOut();
      this.currentUser = null;
    }
  }

  async fetchDevices() {
    try {
      if (this.database) {
        const snapshot = await this.database.ref('devices').once('value');
        return snapshot.val() || {};
      }
    } catch (e) {
      console.warn("Database SDK fetch failed, falling back to REST:", e);
    }
    try {
      const token = this.auth && this.auth.currentUser ? await this.auth.currentUser.getIdToken() : '';
      const url = 'https://worktime-33fa5-default-rtdb.firebaseio.com/devices.json' + (token ? `?auth=${token}` : '');
      const res = await fetch(url);
      if (res.ok) return (await res.json()) || {};
    } catch (err) {
      console.warn("REST fetch devices notice:", err);
    }
    return {};
  }

  async fetchFeedbacks() {
    try {
      if (this.database) {
        const snapshot = await this.database.ref('feedbacks').once('value');
        return snapshot.val() || {};
      }
    } catch (e) {
      console.warn("Database SDK fetch feedbacks failed, falling back to REST:", e);
    }
    try {
      const token = this.auth && this.auth.currentUser ? await this.auth.currentUser.getIdToken() : '';
      const url = 'https://worktime-33fa5-default-rtdb.firebaseio.com/feedbacks.json' + (token ? `?auth=${token}` : '');
      const res = await fetch(url);
      if (res.ok) return (await res.json()) || {};
    } catch (err) {
      console.warn("REST fetch feedbacks notice:", err);
    }
    return {};
  }

  async fetchUsers() {
    try {
      if (this.database) {
        const snapshot = await this.database.ref('users').once('value');
        return snapshot.val() || {};
      }
    } catch (e) {
      console.warn("Database SDK fetch users failed, falling back to REST:", e);
    }
    try {
      const token = this.auth && this.auth.currentUser ? await this.auth.currentUser.getIdToken() : '';
      const url = 'https://worktime-33fa5-default-rtdb.firebaseio.com/users.json' + (token ? `?auth=${token}` : '');
      const res = await fetch(url);
      if (res.ok) return (await res.json()) || {};
    } catch (err) {
      console.warn("REST fetch users notice:", err);
    }
    return {};
  }

  // Live real-time listener for devices
  listenDevices(callback) {
    if (!this.database) return null;
    const ref = this.database.ref('devices');
    ref.on('value', (snapshot) => {
      callback(snapshot.val() || {});
    });
    return ref;
  }

  // Live real-time listener for feedbacks
  listenFeedbacks(callback) {
    if (!this.database) return null;
    const ref = this.database.ref('feedbacks');
    ref.on('value', (snapshot) => {
      callback(snapshot.val() || {});
    });
    return ref;
  }

  // Save or Update User in /users
  async saveUser(userData) {
    const email = (userData.email || '').trim().toLowerCase();
    const key = userData.key || email.replace(/\./g, ',');
    if (!key) throw new Error('Email is required');

    const payload = {
      email: userData.email,
      deviceToken: userData.deviceToken || '',
      subscriptionDate: userData.subscriptionDate || new Date().toISOString().split('T')[0],
      subscriptionExpiryDate: userData.subscriptionExpiryDate || '',
      plan: userData.plan || 'سنوي 👑',
      status: userData.status || 'نشط'
    };

    try {
      if (this.database) {
        await this.database.ref('users/' + key).update(payload);
        return { id: key, ...payload };
      }
    } catch (e) {
      console.warn("Database SDK save user failed, falling back to REST PATCH:", e);
    }

    const token = this.auth && this.auth.currentUser ? await this.auth.currentUser.getIdToken() : '';
    const url = `https://worktime-33fa5-default-rtdb.firebaseio.com/users/${encodeURIComponent(key)}.json` + (token ? `?auth=${token}` : '');
    const res = await fetch(url, {
      method: 'PATCH',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    });
    if (!res.ok) throw new Error('Failed to save user: HTTP ' + res.status);
    return { id: key, ...payload };
  }

  // Delete User from /users
  async deleteUser(userKey) {
    try {
      if (this.database) {
        await this.database.ref('users/' + userKey).remove();
        return true;
      }
    } catch (e) {
      console.warn("Database SDK remove failed, falling back to REST DELETE:", e);
    }
    const res = await fetch(`https://worktime-33fa5-default-rtdb.firebaseio.com/users/${encodeURIComponent(userKey)}.json`, {
      method: 'DELETE'
    });
    if (!res.ok) throw new Error('Failed to delete user: HTTP ' + res.status);
    return true;
  }

  // Delete Device from /devices
  async deleteDevice(uuid) {
    try {
      if (this.database) {
        await this.database.ref('devices/' + uuid).remove();
        return true;
      }
    } catch (e) {
      console.warn("Database SDK remove failed, falling back to REST DELETE:", e);
    }
    const res = await fetch(`https://worktime-33fa5-default-rtdb.firebaseio.com/devices/${encodeURIComponent(uuid)}.json`, {
      method: 'DELETE'
    });
    if (!res.ok) throw new Error('Failed to delete device: HTTP ' + res.status);
    return true;
  }

  // Delete Feedback from /feedbacks
  async deleteFeedback(id) {
    try {
      if (this.database) {
        await this.database.ref('feedbacks/' + id).remove();
        return true;
      }
    } catch (e) {
      console.warn("Database SDK remove feedback failed, falling back to REST DELETE:", e);
    }
    const token = this.auth && this.auth.currentUser ? await this.auth.currentUser.getIdToken() : '';
    const url = `https://worktime-33fa5-default-rtdb.firebaseio.com/feedbacks/${encodeURIComponent(id)}.json` + (token ? `?auth=${token}` : '');
    const res = await fetch(url, { method: 'DELETE' });
    if (!res.ok) throw new Error('Failed to delete feedback: HTTP ' + res.status);
    return true;
  }

  // ─── WHAT'S NEW (تحديثات التطبيق وما الجديد) ─────────────────────────────────
  async fetchWhatsNew() {
    try {
      if (this.database) {
        const snapshot = await this.database.ref('whats_new').once('value');
        return snapshot.val() || {};
      }
    } catch (e) {
      console.warn("Database SDK fetch whats_new failed, falling back to REST:", e);
    }
    try {
      const res = await fetch('https://worktime-33fa5-default-rtdb.firebaseio.com/whats_new.json');
      if (res.ok) return (await res.json()) || {};
    } catch (err) {
      console.warn("REST fetch whats_new notice:", err);
    }
    return {};
  }

  async saveWhatsNew(item) {
    const key = item.id || ('release_' + Date.now());
    const payload = {
      version: item.version || '',
      title: item.title || '',
      description: item.description || '',
      date: item.date || new Date().toISOString().split('T')[0],
      tag: item.tag || 'ميزات جديدة 🚀',
      features: item.features || [],
      isHighlight: !!item.isHighlight
    };

    try {
      if (this.database) {
        await this.database.ref('whats_new/' + key).set(payload);
        return { id: key, ...payload };
      }
    } catch (e) {
      console.warn("Database SDK save whats_new failed, falling back to REST PUT:", e);
    }

    const res = await fetch(`https://worktime-33fa5-default-rtdb.firebaseio.com/whats_new/${encodeURIComponent(key)}.json`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    });
    if (!res.ok) throw new Error('Failed to save whats_new: HTTP ' + res.status);
    return { id: key, ...payload };
  }

  async deleteWhatsNew(key) {
    try {
      if (this.database) {
        await this.database.ref('whats_new/' + key).remove();
        return true;
      }
    } catch (e) {
      console.warn("Database SDK remove whats_new failed, falling back to REST DELETE:", e);
    }
    const token = this.auth && this.auth.currentUser ? await this.auth.currentUser.getIdToken() : '';
    const res = await fetch(`https://worktime-33fa5-default-rtdb.firebaseio.com/whats_new/${encodeURIComponent(key)}.json` + (token ? `?auth=${token}` : ''), {
      method: 'DELETE'
    });
    if (!res.ok) throw new Error('Failed to delete whats_new: HTTP ' + res.status);
    return true;
  }

  async clearAllWhatsNew() {
    try {
      if (this.database) {
        await this.database.ref('whats_new').remove();
        return true;
      }
    } catch (e) {
      console.warn("Database SDK remove all whats_new failed, falling back to REST DELETE:", e);
    }
    const token = this.auth && this.auth.currentUser ? await this.auth.currentUser.getIdToken() : '';
    const res = await fetch('https://worktime-33fa5-default-rtdb.firebaseio.com/whats_new.json' + (token ? `?auth=${token}` : ''), {
      method: 'DELETE'
    });
    if (!res.ok) throw new Error('Failed to clear whats_new: HTTP ' + res.status);
    return true;
  }

  listenWhatsNew(callback) {
    if (!this.database) return null;
    const ref = this.database.ref('whats_new');
    ref.on('value', (snapshot) => {
      callback(snapshot.val() || {});
    });
    return ref;
  }

  // ─── IN-APP ALERTS & MESSAGING (تنبيهات ورسائل داخل التطبيق) ─────────────────
  async sendInAppAlert(alertData) {
    const isBroadcast = alertData.isBroadcast === true;
    const alertId = alertData.id || ('alert_' + Date.now());
    const payload = {
      title: (alertData.title || '').trim(),
      message: (alertData.message || '').trim(),
      type: alertData.type || 'info',
      actionText: (alertData.actionText || 'حسناً').trim(),
      actionUrl: (alertData.actionUrl || '').trim(),
      isRead: false,
      createdAt: new Date().toISOString()
    };

    if (isBroadcast) {
      payload.active = true;
      payload.id = alertId;
      try {
        if (this.database) {
          await this.database.ref('broadcast_alert').set(payload);
          return payload;
        }
      } catch (e) {
        console.warn("Database SDK broadcast alert failed, falling back to REST:", e);
      }
      const token = this.auth && this.auth.currentUser ? await this.auth.currentUser.getIdToken() : '';
      const url = 'https://worktime-33fa5-default-rtdb.firebaseio.com/broadcast_alert.json' + (token ? `?auth=${token}` : '');
      const res = await fetch(url, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload)
      });
      if (!res.ok) throw new Error('Failed to send broadcast alert: HTTP ' + res.status);
      return payload;
    } else {
      const uuid = (alertData.uuid || '').trim();
      if (!uuid) throw new Error('Target user UUID is required');
      try {
        if (this.database) {
          await this.database.ref(`user_alerts/${uuid}/${alertId}`).set(payload);
          return payload;
        }
      } catch (e) {
        console.warn("Database SDK targeted alert failed, falling back to REST:", e);
      }
      const token = this.auth && this.auth.currentUser ? await this.auth.currentUser.getIdToken() : '';
      const url = `https://worktime-33fa5-default-rtdb.firebaseio.com/user_alerts/${encodeURIComponent(uuid)}/${encodeURIComponent(alertId)}.json` + (token ? `?auth=${token}` : '');
      const res = await fetch(url, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload)
      });
      if (!res.ok) throw new Error('Failed to send targeted alert: HTTP ' + res.status);
    }

    // Save record to /sent_alerts for dashboard sent history
    const sentRecord = {
      ...payload,
      id: alertId,
      isBroadcast: isBroadcast,
      targetUuid: isBroadcast ? 'all' : (alertData.uuid || '').trim()
    };
    try {
      if (this.database) {
        await this.database.ref(`sent_alerts/${alertId}`).set(sentRecord);
      } else {
        const token = this.auth && this.auth.currentUser ? await this.auth.currentUser.getIdToken() : '';
        await fetch(`https://worktime-33fa5-default-rtdb.firebaseio.com/sent_alerts/${encodeURIComponent(alertId)}.json` + (token ? `?auth=${token}` : ''), {
          method: 'PUT',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(sentRecord)
        });
      }
    } catch (_) {}

    return payload;
  }

  // Fetch all sent alerts (combining sent_alerts, broadcast_alert, and user_alerts)
  async fetchSentAlerts() {
    const results = [];
    try {
      // 1. Fetch from sent_alerts
      let sentRaw = {};
      try {
        if (this.database) {
          const snap = await this.database.ref('sent_alerts').once('value');
          sentRaw = snap.val() || {};
        } else {
          const res = await fetch('https://worktime-33fa5-default-rtdb.firebaseio.com/sent_alerts.json');
          if (res.ok) sentRaw = (await res.json()) || {};
        }
      } catch (_) {}
      Object.keys(sentRaw).forEach(id => {
        results.push({ id, ...sentRaw[id] });
      });

      // 2. Fetch current broadcast_alert
      try {
        let bCast = null;
        if (this.database) {
          const snap = await this.database.ref('broadcast_alert').once('value');
          bCast = snap.val();
        } else {
          const res = await fetch('https://worktime-33fa5-default-rtdb.firebaseio.com/broadcast_alert.json');
          if (res.ok) bCast = await res.json();
        }
        if (bCast && bCast.title && !results.some(r => r.id === bCast.id)) {
          results.push({
            id: bCast.id || 'broadcast_current',
            isBroadcast: true,
            targetUuid: 'all',
            title: bCast.title,
            message: bCast.message,
            createdAt: bCast.createdAt,
            active: bCast.active
          });
        }
      } catch (_) {}

      // 3. Fetch from user_alerts
      try {
        let userAlertsRaw = {};
        if (this.database) {
          const snap = await this.database.ref('user_alerts').once('value');
          userAlertsRaw = snap.val() || {};
        } else {
          const res = await fetch('https://worktime-33fa5-default-rtdb.firebaseio.com/user_alerts.json');
          if (res.ok) userAlertsRaw = (await res.json()) || {};
        }
        Object.keys(userAlertsRaw).forEach(uuid => {
          const userMap = userAlertsRaw[uuid] || {};
          Object.keys(userMap).forEach(alertId => {
            if (!results.some(r => r.id === alertId)) {
              results.push({
                id: alertId,
                isBroadcast: false,
                targetUuid: uuid,
                ...userMap[alertId]
              });
            }
          });
        });
      } catch (_) {}
    } catch (e) {
      console.warn("fetchSentAlerts error:", e);
    }

    results.sort((a, b) => new Date(b.createdAt || 0) - new Date(a.createdAt || 0));
    return results;
  }

  // Delete a sent alert
  async deleteSentAlert(alertId, targetUuid, isBroadcast) {
    try {
      if (this.database) {
        await this.database.ref(`sent_alerts/${alertId}`).remove();
      } else {
        await fetch(`https://worktime-33fa5-default-rtdb.firebaseio.com/sent_alerts/${encodeURIComponent(alertId)}.json`, { method: 'DELETE' });
      }

      if (isBroadcast) {
        if (this.database) {
          await this.database.ref('broadcast_alert').remove();
        } else {
          await fetch('https://worktime-33fa5-default-rtdb.firebaseio.com/broadcast_alert.json', { method: 'DELETE' });
        }
      } else if (targetUuid && targetUuid !== 'all') {
        if (this.database) {
          await this.database.ref(`user_alerts/${targetUuid}/${alertId}`).remove();
        } else {
          await fetch(`https://worktime-33fa5-default-rtdb.firebaseio.com/user_alerts/${encodeURIComponent(targetUuid)}/${encodeURIComponent(alertId)}.json`, { method: 'DELETE' });
        }
      }
      return true;
    } catch (e) {
      console.warn("deleteSentAlert error:", e);
      throw e;
    }
  }

  async fetchUserAlerts(uuid) {
    if (!uuid) return {};
    try {
      if (this.database) {
        const snapshot = await this.database.ref(`user_alerts/${uuid}`).once('value');
        return snapshot.val() || {};
      }
    } catch (e) {
      console.warn("Database SDK fetch alerts failed, falling back to REST:", e);
    }
    try {
      const token = this.auth && this.auth.currentUser ? await this.auth.currentUser.getIdToken() : '';
      const url = `https://worktime-33fa5-default-rtdb.firebaseio.com/user_alerts/${encodeURIComponent(uuid)}.json` + (token ? `?auth=${token}` : '');
      const res = await fetch(url);
      if (res.ok) return (await res.json()) || {};
    } catch (_) {}
    return {};
  }
}

window.firebaseService = new FirebaseService();
