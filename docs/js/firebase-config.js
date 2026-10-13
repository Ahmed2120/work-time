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
        const val = snapshot.val();
        if (val && Object.keys(val).length > 0) return val;
      }
    } catch (e) {
      console.warn("Database SDK fetch failed, falling back to REST:", e);
    }
    // Direct REST API fallback
    const res = await fetch('https://worktime-33fa5-default-rtdb.firebaseio.com/devices.json');
    if (!res.ok) throw new Error('Failed to fetch devices: HTTP ' + res.status);
    return (await res.json()) || {};
  }

  async fetchFeedbacks() {
    try {
      if (this.database) {
        const snapshot = await this.database.ref('feedbacks').once('value');
        const val = snapshot.val();
        if (val && Object.keys(val).length > 0) return val;
      }
    } catch (e) {
      console.warn("Database SDK fetch feedbacks failed, falling back to REST:", e);
    }
    const res = await fetch('https://worktime-33fa5-default-rtdb.firebaseio.com/feedbacks.json');
    if (!res.ok) throw new Error('Failed to fetch feedbacks: HTTP ' + res.status);
    return (await res.json()) || {};
  }

  async fetchUsers() {
    try {
      if (this.database) {
        const snapshot = await this.database.ref('users').once('value');
        const val = snapshot.val();
        if (val && Object.keys(val).length > 0) return val;
      }
    } catch (e) {
      console.warn("Database SDK fetch users failed, falling back to REST:", e);
    }
    const res = await fetch('https://worktime-33fa5-default-rtdb.firebaseio.com/users.json');
    if (!res.ok) throw new Error('Failed to fetch users: HTTP ' + res.status);
    return (await res.json()) || {};
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
}

window.firebaseService = new FirebaseService();
