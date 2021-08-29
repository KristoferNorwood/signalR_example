using System.Threading.Tasks;
using signalR_example.Api.Models;
using Microsoft.AspNetCore.SignalR;
using signalR_example.Api.Hubs.Clients;

// A SignalR hub is required to 

namespace signalR_example.Api.Hubs
{
	// The Hub<T> class allows us to inject an Interface to use with all Clients
	public class ChatHub : Hub<IChatClient>
	{
		// SendMessage will send a ChatMessage to all clients that are listening to the ReceiveMessage event.
		public async Task SendMessage(ChatMessage message)
		{
			await Clients.All.ReceiveMessage(message);
		}
	}
}