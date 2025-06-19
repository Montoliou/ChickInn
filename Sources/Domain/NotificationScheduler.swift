import UserNotifications
import Foundation
import Combine

final class NotificationScheduler: ObservableObject {
    static let shared = NotificationScheduler()
    private init() { }

    private let center = UNUserNotificationCenter.current()

    func requestAuthorization() async {
        _ = try? await center.requestAuthorization(options: [.alert, .sound, .badge])
    }

    func scheduleNoEggReminder(for chickenName: String, daysWithoutEgg: Int = 3) {
        let content = UNMutableNotificationContent()
        content.title = "⚠️  \(chickenName) hat seit \(daysWithoutEgg) Tagen kein Ei gelegt."
        content.sound = .default

        var date = DateComponents()
        date.hour = 20

        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let request = UNNotificationRequest(identifier: "noEgg_\(chickenName)", content: content, trigger: trigger)
        center.add(request)
    }

    func scheduleWeeklySummary() {
        let content = UNMutableNotificationContent()
        content.title = "📊 Wöchentliche Eier-Übersicht"
        content.body = "Öffne ChickInn für Details."
        content.sound = .default

        var date = DateComponents()
        date.weekday = 2 // Monday
        date.hour = 8

        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        center.add(UNNotificationRequest(identifier: "weeklySummary", content: content, trigger: trigger))
    }
}
