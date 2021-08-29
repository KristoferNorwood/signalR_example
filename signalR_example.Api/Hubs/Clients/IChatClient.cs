using System.Threading.Tasks;
using signalR_example.Api.Models;

namespace signalR_example.Api.Hubs.Clients
{
	public interface IChatClient
	{
		Task ReceiveMessage(ChatMessage message);
	}
}