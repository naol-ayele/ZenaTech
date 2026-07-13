require("dotenv").config();
const admin = require("firebase-admin");

let serviceAccount;

try {
  const filePath = process.env.FIREBASE_SERVICE_ACCOUNT_PATH;
  if (filePath) {
    serviceAccount = require("path").resolve(filePath);
  }
} catch (e) {
  console.log("Firebase: Service account file not found, trying env var");
}

if (!serviceAccount) {
  try {
    serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);
  } catch (e) {
    console.log("Firebase: No service account configured");
  }
}

if (serviceAccount && !admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
  });
}

const FCM_TOPIC = "techpulse_new_articles";

class NotificationService {
  static async sendNewArticleNotification(article) {
    if (!admin.apps.length) {
      console.log("Firebase not initialized, skipping notification");
      return { sent: false, reason: "Firebase not configured" };
    }

    try {
      const message = {
        notification: {
          title: "📰 New Article",
          body: article.title,
        },
        data: {
          articleId: article.id,
          category: article.category,
          type: "new_article",
        },
        android: {
          priority: "high",
          notification: {
            channelId: "techpulse_channel",
          },
        },
        apns: {
          payload: {
            aps: {
              mutableContent: true,
            },
          },
        },
        topic: FCM_TOPIC,
      };

      const response = await admin.messaging().send(message);
      console.log(`Firebase: Notification sent to topic ${FCM_TOPIC}`);
      return { sent: true, messageId: response };
    } catch (error) {
      console.error("Firebase error:", error);
      return { sent: false, error: error.message };
    }
  }

  static async sendToDevice(deviceToken, title, body, data = {}) {
    if (!admin.apps.length) {
      return { sent: false, reason: "Firebase not configured" };
    }

    try {
      const message = {
        notification: { title, body },
        data: { ...data, type: "direct" },
        token: deviceToken,
      };

      const response = await admin.messaging().send(message);
      return { sent: true, messageId: response };
    } catch (error) {
      console.error("Firebase error:", error);
      return { sent: false, error: error.message };
    }
  }

  static async subscribeToTopic(deviceToken, topic = FCM_TOPIC) {
    if (!admin.apps.length) {
      return { success: false, reason: "Firebase not configured" };
    }

    try {
      await admin.messaging().subscribeToTopic(deviceToken, topic);
      return { success: true };
    } catch (error) {
      console.error("Subscribe error:", error);
      return { success: false, error: error.message };
    }
  }

  static async unsubscribeFromTopic(deviceToken, topic = FCM_TOPIC) {
    if (!admin.apps.length) {
      return { success: false, reason: "Firebase not configured" };
    }

    try {
      await admin.messaging().unsubscribeFromTopic(deviceToken, topic);
      return { success: true };
    } catch (error) {
      console.error("Unsubscribe error:", error);
      return { success: false, error: error.message };
    }
  }
}

module.exports = NotificationService;
