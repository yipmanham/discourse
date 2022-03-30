# frozen_string_literal: true

describe UploadReference do
  context 'user uploads' do
    fab!(:user) { Fabricate(:user) }
    let(:filename) { 'small.pdf' }
    let(:file) { file_from_fixtures(filename, 'pdf') }

    before do
      SiteSetting.authorized_extensions = 'pdf'
    end

    it 'creates upload references' do
      upload = nil
      expect { upload = UploadCreator.new(file, filename).create_for(user.id) }
        .to change { UploadReference.count }.by(1)

      upload_reference = UploadReference.last
      expect(upload_reference.upload).to eq(upload)
      expect(upload_reference.target).to eq(user)
    end
  end

  context 'post uploads' do
    fab!(:upload) { Fabricate(:upload) }
    fab!(:post) { Fabricate(:post, raw: "[](#{upload.short_url})") }

    it 'creates upload references' do
      expect { post.link_post_uploads }
        .to change { UploadReference.count }.by(1)

      upload_reference = UploadReference.last
      expect(upload_reference.upload).to eq(upload)
      expect(upload_reference.target).to eq(post)

      expect { post.destroy! }
        .to change { UploadReference.count }.by(-1)
    end
  end

  context 'site setting uploads' do
    let(:provider) { SiteSettings::DbProvider.new(SiteSetting) }
    fab!(:upload) { Fabricate(:upload) }

    it 'creates upload references' do
      expect { provider.save('logo', upload.id, SiteSettings::TypeSupervisor.types[:upload]) }
        .to change { UploadReference.count }.by(1)

      upload_reference = UploadReference.last
      expect(upload_reference.upload).to eq(upload)
      expect(upload_reference.target).to eq(SiteSetting.find_by(name: 'logo'))

      expect { provider.destroy('logo') }
        .to change { UploadReference.count }.by(-1)
    end
  end

  context 'badge uploads' do
    fab!(:upload) { Fabricate(:upload) }

    it 'creates upload references' do
      badge = nil
      expect { badge = Fabricate(:badge, image_upload_id: upload.id) }
        .to change { UploadReference.count }.by(1)

      upload_reference = UploadReference.last
      expect(upload_reference.upload).to eq(upload)
      expect(upload_reference.target).to eq(badge)

      expect { badge.destroy! }
        .to change { UploadReference.count }.by(-1)
    end
  end

  context 'group uploads' do
    fab!(:upload) { Fabricate(:upload) }

    it 'creates upload references' do
      group = nil
      expect { group = Fabricate(:group, flair_upload_id: upload.id) }
        .to change { UploadReference.count }.by(1)

      upload_reference = UploadReference.last
      expect(upload_reference.upload).to eq(upload)
      expect(upload_reference.target).to eq(group)

      expect { group.destroy! }
        .to change { UploadReference.count }.by(-1)
    end
  end

  context 'user export uploads' do
    fab!(:upload) { Fabricate(:upload) }

    it 'creates upload references' do
      user_export = nil
      expect do
        user_export = UserExport.create!(
          file_name: 'export',
          user: Fabricate(:user),
          upload: upload,
          topic: Fabricate(:topic),
        )
      end.to change { UploadReference.count }.by(1)

      upload_reference = UploadReference.last
      expect(upload_reference.upload).to eq(upload)
      expect(upload_reference.target).to eq(user_export)

      expect { user_export.destroy! }
        .to change { UploadReference.count }.by(-1)
    end
  end
end
