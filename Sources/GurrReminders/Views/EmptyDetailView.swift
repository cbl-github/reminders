import SwiftUI

struct EmptyDetailView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "bell.badge")
                .font(.system(size: 44, weight: .semibold))
                .foregroundStyle(.secondary)

            Text("选择或新建提醒")
                .font(.title3.weight(.semibold))
                .foregroundStyle(.primary)

            Button {
                NotificationCenter.default.post(name: .createReminderRequested, object: nil)
            } label: {
                Label("新建提醒", systemImage: "plus")
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.background)
    }
}
