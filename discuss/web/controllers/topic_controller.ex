defmodule Discuss.TopicController do
  use Discuss.Web, :controller
  alias Discuss.Topic

  @doc """
  See the form to create a new topic
  """
  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  @doc """
  Submit the form to create a topic
  """
  def create(conn, %{"topic" => topic}) do
    insert =
      %Topic{}
      |> Topic.changeset(topic)
      |> Repo.insert()

    case insert do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Created")
        |> redirect(to: topic_path(conn, :index))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  @doc """
  Get a list of all topics
  """
  def index(conn, _params) do
    topics = Topic |> order_by(desc: :id) |> Repo.all()
    render(conn, "index.html", topics: topics)
  end

  @doc """
  See the form to update topic by it's id
  """
  def edit(conn, %{"id" => topic_id}) do
    topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(topic)
    render(conn, "edit.html", changeset: changeset, topic: topic)
  end

  @doc """
  Submit the form to update a topic by it's id
  """
  def update(conn, %{"id" => topic_id, "topic" => topic}) do
    old_topic = Repo.get(Topic, topic_id)
    update = old_topic |> Topic.changeset(topic) |> Repo.update()

    case update do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Updated")
        |> redirect(to: topic_path(conn, :index))

      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset, topic: old_topic)
    end
  end

  @doc """
  Delete a topic by it's id
  """
  def delete(conn, %{"id" => topic_id}) do
    # Topic |> Repo.get!(topic_id) |> Repo.delete!()
    # conn |> put_flash(:info, "Topic Deleted") |> redirect(to: topic_path(conn, :index))

    delete =
      Topic
      |> Repo.get(topic_id)
      |> Repo.delete()

    case delete do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Deleted")
        |> redirect(to: topic_path(conn, :index))

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Couldn't delete topic")
        |> redirect(to: topic_path(conn, :index))
    end
  end
end
