class RecipeDecorator < SimpleDelegator
  def resized_recipe_thumbnail(size: 100)

    if thumbnail.present?
      thumbnail = __getobj__.thumbnail # __getobj__でデコレートされたRecipeインスタンスのthumbnailを取得
    else
      thumbnail = ActiveStorage::Blob.find_by(filename: "sample.jpg").attachments.first
    end

    # resize_to_fillを使って画像をトリミングし、指定したサイズに合わせる
    thumbnail.variant(resize_to_fill: [size, size])
  end
end
