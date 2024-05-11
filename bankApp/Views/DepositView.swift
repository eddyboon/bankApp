import SwiftUI
import Combine

struct DepositView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var navigationController: NavigationController
    @StateObject var viewModel: DepositViewModel
    @Environment(\.dismiss) var dismiss
    
    init() {
        _viewModel = StateObject(wrappedValue: DepositViewModel())
    }
    
    var body: some View {
        VStack {
            Text("Deposit")
                .font(.largeTitle)
                .bold()
                .padding(60)
            Text("Amount to add")
                .padding(.top)
            HStack {
                Text("$")
                TextField("", value: $viewModel.depositAmount, format: .number)
                    .padding(.horizontal)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 250, height: 50)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
            }
            HStack(spacing: 20) {
                ForEach(viewModel.depositSuggestions, id: \.self) { suggestion in
                    Button(action: {
                        viewModel.depositAmount = suggestion
                    }) {
                        Text("\(suggestion)")
                            .fontWeight(.semibold)
                            .padding()
                    }
                }
            }
            if(viewModel.requestInProgress) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
            }
            else {
                Button(action: {
                    Task {
                        await viewModel.depositMoney(depositAmount: viewModel.depositAmount, authViewModel: authViewModel)
                    }
                    
                }) {
                    Text("Submit")
                        .font(.title2)
                        .frame(maxWidth: .infinity)
                        .frame(width: 250, height: 50)
                        .background(Color.green)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding()
                        .foregroundColor(.white)
                }
            }
            
        }
        .fullScreenCover(isPresented: $viewModel.showDepositConfirmationView) {
            DepositConfirmationView(depositAmount: viewModel.depositAmount, showFullscreenCover: $viewModel.showDepositConfirmationView, transactionDismissed: $viewModel.transactionDismissed)
        }
        .onReceive(viewModel.$transactionDismissed) { transactionIsDismissed in
            if(transactionIsDismissed) {
                navigationController.currentTab = NavigationController.Tab.dashboard
                dismiss()
            }
        }
    }
}

#Preview {
    DepositView()
        .environmentObject(AuthViewModel())
}
