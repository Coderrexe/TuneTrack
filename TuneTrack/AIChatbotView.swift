import SwiftUI

struct AIChatbotView: View {
    @State private var userQuery: String = ""
    @State private var chatbotResponse: String = ""
    @State private var isLoading: Bool = false
    @State private var showErrorAlert: Bool = false
    @State private var errorMessage: String = ""

    let apiKey = "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"

    func getChatbotResponse() {
        guard !userQuery.isEmpty else {
            errorMessage = "Query cannot be empty!"
            showErrorAlert = true
            return
        }

        isLoading = true

        let openAIURL = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: openAIURL)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "model": "gpt-3.5-turbo", // change to gpt-4 later
            "messages": [
                ["role": "system", "content": "You play the role of an AI assistant for Tunetrack,"],
                ["role": "user", "content": userQuery]
            ],
            "max_tokens": 150
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        // request
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                if let error = error {
                    errorMessage = "Error: \(error.localizedDescription)"
                    showErrorAlert = true
                    return
                }

                guard let data = data else {
                    errorMessage = "No data returned from OpenAI server."
                    showErrorAlert = true
                    return
                }
                
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw response: \(jsonString)")
                }

                // Parse
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]],
                   let message = choices.first?["message"] as? [String: Any],
                   let content = message["content"] as? String {
                    chatbotResponse = content
                } else {
                    errorMessage = "Unable to parse response from OpenAI."
                    showErrorAlert = true
                }
            }
        }.resume()
    }

    var body: some View {
        NavigationView {
            VStack {
                Text("Ask Tunetrack's AI Assistant")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()

                TextField("Enter your question", text: $userQuery)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Button(action: getChatbotResponse) {
                    Text("Ask AI")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .disabled(isLoading)
                .opacity(isLoading ? 0.6 : 1.0)

                if isLoading {
                    ProgressView("Waiting for AI response...")
                        .padding()
                }

                ScrollView {
                    VStack(alignment: .leading) {
                        if !chatbotResponse.isEmpty {
                            Text("AI Response:")
                                .font(.headline)
                                .padding(.top)

                            Text(chatbotResponse)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                }

                Spacer()
            }
            .padding()
            .navigationTitle("AI Assistant")
            .alert(isPresented: $showErrorAlert) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct AIChatbotView_Previews: PreviewProvider {
    static var previews: some View {
        AIChatbotView()
    }
}
