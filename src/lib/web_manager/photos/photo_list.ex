defmodule WebManager.Photos.PhotoList do
  defstruct( photos: [] )

  def show_photos(photos, :all) do
    photos
  end

  def show_photos(photos, :rejected) do
    Enum.filter(photos, &rejected?/1)
  end

  def show_photos(photos, :accepted) do
    Enum.filter(photos, &accepted?/1)
  end
  def show_photos(photos, :pending) do
    Enum.filter(photos, &pending?/1)
  end

  def rejected?(photo) do
    photo.status == :rejected
  end

  def accepted?(photo) do
    photo.status == :accepted
  end

  def pending?(photo) do
    photo.status == :pending
  end

  def add_photo(list, photo) do
    [photo|list]
  end

  def accept(photos, id) do
    accepted_photo = photos
    |> Enum.find(fn x -> x.id == id end)
    |> Photo.accept

    index = Enum.find_index(photos, fn x -> x.id == id end)
    List.replace_at(photos, index, accepted_photo)
  end


  def reject(photos, id) do
    rejected_photo = photos
    |> Enum.find(fn x -> x.id == id end)
    |> Photo.reject

    index = Enum.find_index(photos, fn x -> x.id == id end)
    List.replace_at(photos, index, rejected_photo)
  end

  def next_photo(photos, photo) do
    current_photo_index = Enum.find_index(photos, fn x -> x == photo end)
    Enum.fetch!(photos, current_photo_index+1)
    #TODO wrap around the list if last photo
  end
end